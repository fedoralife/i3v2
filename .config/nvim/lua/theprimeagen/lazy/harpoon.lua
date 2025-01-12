return {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Harpoon requires plenary
    config = function()
        -- Setup Harpoon
        require("harpoon").setup({
            menu = {
                width = vim.api.nvim_win_get_width(0) - 20,
            },
        })

        -- Keybindings for Harpoon
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        -- Add file to Harpoon
        vim.keymap.set("n", "<leader>hh", mark.add_file, { desc = "Add file to Harpoon" })

        -- Open Harpoon menu
        vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = "Open Harpoon menu" })

        -- Navigate between files
        vim.keymap.set("n", "<leader>h1", function() ui.nav_file(1) end, { desc = "Navigate to Harpoon file 1" })
        vim.keymap.set("n", "<leader>h2", function() ui.nav_file(2) end, { desc = "Navigate to Harpoon file 2" })
        vim.keymap.set("n", "<leader>h3", function() ui.nav_file(3) end, { desc = "Navigate to Harpoon file 3" })
        vim.keymap.set("n", "<leader>h4", function() ui.nav_file(4) end, { desc = "Navigate to Harpoon file 4" })
    end,
}

