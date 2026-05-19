local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = 0, silent = true, desc = desc })
end

-- Lifecycle
map("<leader>Fr", "<cmd>FlutterRun<CR>", "Flutter Run")
map("<leader>Fq", "<cmd>FlutterQuit<CR>", "Flutter Quit")
map("<leader>FR", "<cmd>FlutterRestart<CR>", "Flutter Restart (hot)")
map("<leader>Fl", "<cmd>FlutterReload<CR>", "Flutter Reload (hot)")

-- Devices / emulators
map("<leader>Fd", "<cmd>FlutterDevices<CR>", "Flutter Devices")
map("<leader>Fe", "<cmd>FlutterEmulators<CR>", "Flutter Emulators (start)")
map("<leader>Fk", function()
  local commands = {
    { "adb", "emu", "kill" },
    { "xcrun", "simctl", "shutdown", "all" },
  }

  local failed = {}
  local executed = 0

  for _, cmd in ipairs(commands) do
    if vim.fn.executable(cmd[1]) == 1 then
      executed = executed + 1

      local result = vim.system(cmd):wait()

      if result.code ~= 0 then
        table.insert(failed, cmd[1])
      end
    end
  end

  if executed == 0 then
    vim.notify("No emulator tools found in PATH", vim.log.levels.WARN)
    return
  end

  if #failed > 0 then
    vim.notify(
      "Failed to shut down: " .. table.concat(failed, ", "),
      vim.log.levels.ERROR
    )
  else
    vim.notify("All emulators shut down successfully")
  end
end, "Kill all emulators")

-- DevTools / inspector
map("<leader>FD", "<cmd>FlutterDevTools<CR>", "Flutter DevTools")
map("<leader>Fo", "<cmd>FlutterOutlineToggle<CR>", "Toggle Outline")
map("<leader>FL", "<cmd>FlutterLogToggle<CR>", "Toggle Log")

-- Pub
map("<leader>Fp", "<cmd>FlutterPubGet<CR>", "Pub Get")
map("<leader>FP", "<cmd>FlutterPubUpgrade<CR>", "Pub Upgrade")
