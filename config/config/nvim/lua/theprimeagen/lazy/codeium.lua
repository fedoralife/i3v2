return {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    config = function()
        -- Accept suggestion
        vim.keymap.set("i", "<leader><CR>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true })

        -- Cycle forward through suggestions
        vim.keymap.set("i", "<M-]>", function()
            return vim.fn
        end, { expr = true })

        -- Cycle backward through suggestions
        vim.keymap.set("i", "<M-[>", function()
            return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true })

        -- Clear current suggestion
        vim.keymap.set("i", "<M-BS>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true })
    end,
}

