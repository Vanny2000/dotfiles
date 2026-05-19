return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  config = function()
    require("flutter-tools").setup {
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = false,
        },
      },
      dev_log = {
        enabled = true,
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      debugger = {
        enabled = false,
        exception_breakpoints = {},
        register_configurations = function(paths)
          require('dap').configurations.dart = {
            {
              type = 'dart',
              request = 'launch',
              name = 'Launch flutter',
              dartSdkPath = paths.dart_sdk,
              flutterSdkPath = paths.flutter_sdk,
              program = '${workspaceFolder}/lib/main.dart',
              cwd = '${workspaceFolder}',
            },
          }
        end,
      },
    }
  end,

}
