return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
    },
    -- init.lua (Neovim config)

    config = function()
        -- Telescope setup
        require('telescope').setup({
            defaults = {
                winblend = 30,
                winhighlight = "Normal:Normal,FloatBorder:Normal,Search:Search",
                file_ignore_patterns = { "/build", "/.git", "*.lock", "*.swp" },  -- Ignore specific file types or patterns
                hidden = true,  -- Ensure hidden files are shown (excluding those ignored)
            }
        })

        -- Define the Find and Replace function
        local M = {}

        -- Function for performing find and replace
        M.find_and_replace = function()
            -- Step 1: Prompt user for the word to search for
            vim.ui.input({ prompt = "Enter word to search for: " }, function(search_term)
                if not search_term or search_term == "" then
                    print("No search term provided.")
                    return
                end

                -- Step 2: Prompt user for the replacement word
                vim.ui.input({ prompt = "Enter replacement word: " }, function(replacement_term)
                    if not replacement_term or replacement_term == "" then
                        print("No replacement term provided.")
                        return
                    end

                    -- Step 3: Get current buffer content
                    local current_buf = vim.api.nvim_get_current_buf()
                    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

                    -- Step 4: Perform the replacement on each line
                    for i, line in ipairs(lines) do
                        -- Use gsub to replace all occurrences of search_term with replacement_term
                        lines[i] = line:gsub("%f[%a]" .. search_term .. "%f[%A]", replacement_term)
                    end

                    -- Step 5: Apply the replaced content back to the buffer
                    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)

                    -- Print a message that the replacement is complete
                    print("Replaced all occurrences of '" .. search_term .. "' with '" .. replacement_term .. "' in the current buffer.")
                end)
            end)
        end

        -- Keybinding for Find and Replace
        vim.keymap.set("n", "<Leader>fr", function()
            M.find_and_replace()
        end, { noremap = true, silent = true, desc = "Find and Replace with Telescope" })

        -- Keybindings for various Telescope functions
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', function()
            builtin.find_files({
                find_command = {'find', '.', '-not', '-path', './.git/*'},  -- Explicitly exclude files inside .git
            })
        end)

        vim.keymap.set('n', '<C-p>', builtin.git_files)
        vim.keymap.set('n', '<leader>pq', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
