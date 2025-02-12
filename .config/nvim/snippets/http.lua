local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- HTTP Snippets
ls.add_snippets("http", {
	s("req", {
		t("# @name "),
		i(1, "REQUEST_NAME"),
		t({ "", "" }),
		t("{{METHOD}} "),
		i(2, "{{API_URL}}"),
		t({ "", "" }),
		t("Authorization: "),
		i(3, "{{API_KEY}}"),
		t({ "", "###" }),
	}),
	s("get", {
		t("# @name "),
		i(1, "GET_REQUEST_NAME"),
		t({ "", "" }),
		t("GET "),
		i(2, "{{API_URL}}"),
		t({ "", "" }),
		t("Authorization: "),
		i(3, "{{API_KEY}}"),
		t({ "", "###" }),
	}),
	s("post", {
		t("# @name "),
		i(1, "POST_REQUEST_NAME"),
		t({ "", "" }),
		t("POST "),
		i(2, "{{API_URL}}"),
		t({ "", "" }),
		t("Content-Type: application/json"),
		t({ "", "" }),
		t("Authorization: "),
		i(3, "{{API_KEY}}"),
		t({ "", "" }),
		t("Body: "),
		i(4, "{}"),
		t({ "", "###" }),
	}),
})
