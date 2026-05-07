return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()

      local netcore_debugger = vim.fn.exepath 'netcoredbg'
      if netcore_debugger ~= '' then
        dap.adapters.coreclr = {
          type = 'executable',
          command = netcore_debugger,
          args = { '--interpreter=vscode' },
        }
        dap.configurations.cs = {
          {
            type = 'coreclr',
            name = 'launch - netcoredbg',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
          },
        }
      end

      local lldb_debugger = vim.fn.exepath 'lldb-dap'
      if lldb_debugger ~= '' then
        dap.adapters.lldb = {
          type = 'executable',
          command = lldb_debugger,
          name = 'lldb-dap',
        }
        dap.configurations.zig = {
          {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
          },
        }
      end

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F13>', dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
