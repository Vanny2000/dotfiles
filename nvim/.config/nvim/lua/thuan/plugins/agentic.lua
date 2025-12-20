return {
  "carlos-algms/agentic.nvim",

  event = "VeryLazy",

  opts = {
    -- Available by default: "claude-acp" | "gemini-acp" | "codex-acp" | "opencode-acp"
    provider = "opencode-acp", -- setting the name here is all you need to get started
    windows = {
      width = "45%",
      input = {
        height = 10,
      },
    },
  },

  -- these are just suggested keymaps; customize as desired
  keys = {
    {
      "<leader>aa", function() require("agentic").toggle() end,
      mode = { "n", "v", "i" },
      desc = "Toggle Agentic Chat"
    },
    {
      "go",
      function() require("agentic").add_selection_or_file_to_context() end,
      mode = { "n", "v" },
      desc = "Add file or selection to Agentic to Context"
    },
    {
      "<leader>an",
      function() require("agentic").new_session() end,
      mode = { "n", "v", "i" },
      desc = "New Agentic Session"
    },
  },
}
