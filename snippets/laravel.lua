local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

-- PHP Snippets
ls.add_snippets("php", {
	-- __invoke method
	s("inv", {
		t("public function __invoke("),
		i(1),
		t(")"),
		i(2),
		t({ "", "{" }),
		t("    "),
		i(3),
		t({ "", "}" }),
	}),
	-- Public method
	s("pubf", {
		t("public function "),
		i(1),
		t("("),
		i(2),
		t(")"),
		i(3),
		t({ "", "{" }),
		t("    "),
		i(0),
		t({ "", "}" }),
	}),
	-- Protected method
	s("prof", {
		t("protected function "),
		i(1),
		t("("),
		i(2),
		t(")"),
		i(3),
		t({ "", "{" }),
		t("    "),
		i(0),
		t({ "", "}" }),
	}),
	-- Private method
	s("prif", {
		t("private function "),
		i(1),
		t("("),
		i(2),
		t(")"),
		i(3),
		t({ "", "{" }),
		t("    "),
		i(0),
		t({ "", "}" }),
	}),
	-- Public static method
	s("pubsf", {
		t("public static function "),
		i(1),
		t("("),
		i(2),
		t(")"),
		i(3),
		t({ "", "{" }),
		t("    "),
		i(0),
		t({ "", "}" }),
	}),
	-- Pest test (it) method
	s("it", {
		t("it('"),
		i(1),
		t("', function () {"),
		t({ "", "    // Arrange", "    " }),
		i(0),
		t({ "", "", "    // Act", "", "", "    // Assert", "", "});" }),
	}),

	-- Laravel Routes
	s("rroute", {
		t("Route::"),
		c(1, { t("get"), t("post"), t("put"), t("patch"), t("delete") }),
		t("('"),
		i(2, "/path"),
		t("', ["),
		i(3, "Controller::class"),
		t(", '"),
		i(4, "method"),
		t("'])"),
	}),

	-- Route::resource
	s("rresource", {
		t("Route::resource('"),
		i(1, "resource"),
		t("', "),
		i(2, "Controller::class"),
		t(");"),
	}),

	-- Route group
	s("rgroup", {
		t("Route::group(['prefix' => '"),
		i(1, "prefix"),
		t("', 'middleware' => ['"),
		i(2, "middleware"),
		t("']], function () {"),
		t({ "", "    " }),
		i(0, "// Routes go here"),
		t({ "", "});" }),
	}),
})

ls.add_snippets("http", {
	s("req", {
		t("# @name "),
		i(3, "request_name"),
		t({ "", "" }),
		c(1, {
			t("GET"),
			t("POST"),
			t("PUT"),
			t("PATCH"),
			t("DELETE"),
			t("HEAD"),
			t("OPTIONS"),
		}),
		t(" "),
		i(2, "{{API_URL}}/endpoint"),
		t({ "", "Authentication: Bearer {{API_KEY}}" }),
		t({ "", "" }),
		i(0),
		t({ "", "###" }),
	}),
})

-- set keybinds for both INSERT and VISUAL.
vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-prev-choice", {})