-- PlantUML Snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

ls.add_snippets("plantuml", {
	-- Basic Sequence Diagram Template
	s("seq", {
		t({ "@startuml", "" }),
		t("title "),
		i(1, "Diagram Title"),
		t({ "", "" }),
		t("participant "),
		i(2, "Participant1"),
		t(" as "),
		i(3, "P1"),
		t({ "", "participant " }),
		i(4, "Participant2"),
		t(" as "),
		i(5, "P2"),
		t({ "", "", "' Your sequence here", "", "@enduml" }),
	}),

	-- Message
	s("msg", {
		i(1, "Sender"),
		t(" "),
		c(2, {
			t("->"), -- Synchronous message
			t("-->"), -- Asynchronous message
			t("->>"), -- Dotted message
			t("//-->"), -- Lost message
			t("->x"), -- Destruction message
			t("->o"), -- Creation message
		}),
		t(" "),
		i(3, "Receiver"),
		t(" : "),
		i(4, "message"),
	}),

	-- Alternative Flow
	s("alt", {
		t({ "alt " }),
		i(1, "condition"),
		t({ "", "    " }),
		i(2, "message"),
		t({ "", "else" }),
		t({ "", "    " }),
		i(3, "alternative message"),
		t({ "", "end" }),
	}),

	-- Loop
	s("loop", {
		t({ "loop " }),
		i(1, "condition"),
		t({ "", "    " }),
		i(2, "message"),
		t({ "", "end" }),
	}),

	-- Note
	s("note", {
		t("note "),
		c(1, {
			t("left"),
			t("right"),
			t("over"),
		}),
		t(" "),
		i(2, "Participant"),
		t({ "", "    " }),
		i(3, "Note text"),
		t({ "", "end note" }),
	}),

	-- Divider
	s("div", {
		t("== "),
		i(1, "Section Title"),
		t(" =="),
	}),

	-- Participant with Type
	s("part", {
		c(1, {
			t("participant"),
			t("actor"),
			t("boundary"),
			t("control"),
			t("entity"),
			t("database"),
			t("collections"),
		}),
		t(" "),
		i(2, "Name"),
		t(" as "),
		i(3, "Alias"),
	}),

	-- Activation/Deactivation
	s("act", {
		t({ "activate " }),
		i(1, "participant"),
		t({ "", "    " }),
		i(2, "actions"),
		t({ "", "deactivate " }),
		i(3, "participant"),
	}),

	-- Group (opt, loop, par, break, critical)
	s("group", {
		c(1, {
			t("opt"),
			t("loop"),
			t("par"),
			t("break"),
			t("critical"),
		}),
		t(" "),
		i(2, "condition"),
		t({ "", "    " }),
		i(3, "message"),
		t({ "", "end" }),
	}),

	-- Response Message
	s("resp", {
		i(1, "Sender"),
		t(" "),
		c(2, {
			t("-->"),
			t("->"),
		}),
		t(" "),
		i(3, "Receiver"),
		t(" : "),
		i(4, "response"),
	}),

	-- Box around participants
	s("box", {
		t({ "box " }),
		i(1, "Title"),
		t({ " #" }),
		c(2, {
			t("LightBlue"),
			t("LightGreen"),
			t("LightYellow"),
			t("LightGray"),
		}),
		t({ "", "    " }),
		i(3, "participant content"),
		t({ "", "end box" }),
	}),

	-- Delay
	s("delay", {
		t("... "),
		i(1, "delay description"),
		t(" ..."),
	}),

	-- Reference
	s("ref", {
		t({ "ref over " }),
		i(1, "Participant1"),
		t({ ", " }),
		i(2, "Participant2"),
		t({ " : " }),
		i(3, "reference description"),
	}),
})
