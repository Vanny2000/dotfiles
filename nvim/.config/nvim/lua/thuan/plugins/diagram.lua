return {
  'javiorfo/nvim-soil',

  -- Optional for puml syntax highlighting:
  dependencies = { 'javiorfo/nvim-nyctophilia' },

  lazy = true,
  ft = "plantuml",
  opts = {
    -- If you want to change default configurations

    -- This option closes the image viewer and reopen the image generated
    -- When true this offers some kind of online updating (like plantuml web server)
    actions = {
      redraw = true,
    },
    image = {
      darkmode = false, -- Enable or disable darkmode
      format = "png", -- Choose between png or svg
      execute_to_open = function(img)
        return "open " .. img
      end
    }
  },
  vim.keymap.set('n', '<leader>pg', '<cmd>Soil<cr>', { desc = "Render PlantUML diagram" }),
  vim.keymap.set('n', '<leader>po', '<cmd>SoilOpenImg<cr>', { desc = "Open rendered image" }),

}

