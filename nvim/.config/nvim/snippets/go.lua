-- PlantUML Snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("go", {
	-- Error checking snippet
	s("ie", {
		t({ "if err != nil {", "\t" }),
		i(1, "return nil, err"),
		t({ "", "}" }),
	}),
	-- Function snippet
	s("fn", {
		t({ "func " }),
		i(1, "name"),
		t({ "(" }),
		i(2, "params"),
		t({ ") " }),
		i(3, "returnType"),
		t({ " {", "\t" }),
		i(4),
		t({ "", "}" }),
	}),
	-- Struct snippet
	s("str", {
		t({ "type " }),
		i(1, "Name"),
		t({ " struct {", "\t" }),
		i(2),
		t({ "", "}" }),
	}),
	-- Main function snippet
	s("main", {
		t({ "func main() {", "\t" }),
		i(1),
		t({ "", "}" }),
	}),
	-- For loop snippet
	s("for", {
		t({ "for " }),
		i(1, "i := 0"),
		t({ "; " }),
		i(2, "i < 10"),
		t({ "; " }),
		i(3, "i++"),
		t({ " {", "\t" }),
		i(4),
		t({ "", "}" }),
	}),
	-- If statement snippet
	s("if", {
		t({ "if " }),
		i(1, "condition"),
		t({ " {", "\t" }),
		i(2),
		t({ "", "}" }),
	}),
})
