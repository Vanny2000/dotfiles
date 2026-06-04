local function html_to_markdown(text)
	if not text or text == "" then
		return text
	end

	text = text:gsub("<br%s*/?>", "\n")
	text = text:gsub("</p>%s*", "\n\n")
	text = text:gsub("<p>%s*", "")
	text = text:gsub("<pre><code[^>]*>", "\n```\n")
	text = text:gsub("</code></pre>", "\n```\n")
	text = text:gsub("<pre>", "\n```\n")
	text = text:gsub("</pre>", "\n```\n")
	text = text:gsub("<code>", "`")
	text = text:gsub("</code>", "`")
	text = text:gsub("<strong>", "**")
	text = text:gsub("</strong>", "**")
	text = text:gsub("<b>", "**")
	text = text:gsub("</b>", "**")
	text = text:gsub("<em>", "*")
	text = text:gsub("</em>", "*")
	text = text:gsub("<i>", "*")
	text = text:gsub("</i>", "*")
	text = text:gsub("<li>%s*", "- ")
	text = text:gsub("</li>%s*", "\n")
	text = text:gsub("</?[uo]l>%s*", "\n")
	text = text:gsub('<a%s+[^>]-href="([^"]*)"[^>]*>(.-)</a>', "[%2](%1)")
	text = text:gsub("<[^>]+>", "")

	text = text:gsub("&lt;", "<")
	text = text:gsub("&gt;", ">")
	text = text:gsub("&quot;", '"')
	text = text:gsub("&#39;", "'")
	text = text:gsub("&nbsp;", " ")
	text = text:gsub("&amp;", "&")

	text = text:gsub("`%*%*([^`]-)%*%*`", "`%1`")
	text = text:gsub("\\(%p)", "%1")

	text = text:gsub("\n\n\n+", "\n\n")

	return text
end

local function clean_contents(contents)
	if type(contents) == "string" then
		return html_to_markdown(contents)
	end
	if type(contents) == "table" then
		if type(contents.value) == "string" then
			contents.value = html_to_markdown(contents.value)
		elseif vim.islist(contents) then
			for i, item in ipairs(contents) do
				contents[i] = clean_contents(item)
			end
		end
	end
	return contents
end

return {
	on_init = function(client)
		local orig_request = client.request
		client.request = function(self, method, params, handler, bufnr)
			if method == "textDocument/hover" and type(handler) == "function" then
				local wrapped = function(err, result, ctx, config)
					if result and result.contents then
						result.contents = clean_contents(result.contents)
					end
					return handler(err, result, ctx, config)
				end
				return orig_request(self, method, params, wrapped, bufnr)
			end
			return orig_request(self, method, params, handler, bufnr)
		end
	end,
}
