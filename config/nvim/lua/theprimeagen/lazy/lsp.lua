return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Package Management
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        -- Completion
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",

        -- Snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- Add lspsaga.nvim plugin
        "glepnir/lspsaga.nvim",

        -- Treesitter for Syntax Highlighting
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",

        -- Debugging
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",

        -- Formatting & Linting
        "jose-elias-alvarez/null-ls.nvim",

        -- Testing
        "vim-test/vim-test",

        -- Git Integration
        "lewis6991/gitsigns.nvim",

        -- Navigation & Symbols
        "simrat39/symbols-outline.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-tree.lua",

        -- Additional Dependency for nvim-dap-ui
        "nvim-neotest/nvim-nio",
    },

    config = function()
        local cmp = require("cmp")
        local lspconfig = require("lspconfig")
        local luasnip = require("luasnip")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Importing snippet functions from luasnip
        local s = luasnip.s
        local i = luasnip.i
        local t = luasnip.t

        -- Adding C++ snippets
        luasnip.add_snippets("cpp", {
            -- Main function snippet
            s("main", {
                t("int main(int argc, char* argv[]) {"),
                t({"", "\t"}), i(1, "// Your code here"), t({"", "", "}"}),
            }),
            -- Class snippet
            s("class", {
                t("class "), i(1, "ClassName"), t(" {"),
                t({"", "\tpublic:", ""}),
                t("\t"), i(2, "ClassName"), t("("), i(3, "int x = 0"), t({") {", "\t\tthis->x = x;", ""}),
                t("\t}"), t({"", "\t~ClassName() {", "\t\t// Destructor", "\t}", ""}),
                t({"", "\tprivate:", ""}),
                t("\t\tint x;"),
                t({"", "};"})
            }),
            -- Include header snippet (for both system and custom headers)
            s("include", {
                t("#include <"), i(1, "header_name"), t(">"), -- For system headers
            }),
            s("inc", {
                t("#include \""), i(1, "header_name"), t("\""), -- For custom headers
            }),
            -- Additional example C++ snippets
            s("func", {
                t("void "), i(1, "function_name"), t("("), i(2, "int arg"), t(") {"),
                t({ "", "\t" }), i(3, "// body"), t({ "", "}" }),
            }),
            s("for", {
                t("for (int i = 0; i < "), i(1, "n"), t("; i++) {"),
                t({ "", "\t" }), i(2, "// body"), t({ "", "}" }),
            }),
        })

        -- Mason setup
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "rust_analyzer", "clangd", "lua_ls", "cmake", "jsonls" },
            automatic_installation = true,
        })

        -- Setup lspsaga
        require("lspsaga").setup({
            code_action = {
                enable = true,
            },

        })

vim.keymap.set("n", "<Leader>fq", "<Cmd>Lspsaga code_action<CR>", { noremap = true, silent = true })
        -- LSP setup for clangd
        lspconfig.clangd.setup({
            cmd = { "clangd", "--header-insertion=never", "--cross-file-rename" },
            capabilities = capabilities,
            root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json"),
             dynamicRegistration = true,
        })

        -- Treesitter setup
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "rust",  "cpp", "c", "json", "lua" },
            highlight = { enable = true },
            textobjects = { enable = true },
        })

        -- nvim-cmp setup
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)  -- Explicitly expanding snippets from LuaSnip
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        cmp.mapping.select_next_item()(fallback)
                    end
                end),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        cmp.mapping.select_prev_item()(fallback)
                    end
                end),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }),
        })

        -- Formatting and Linting with null-ls
        require("null-ls").setup({
            sources = {
                require("null-ls").builtins.formatting.clang_format,
                require("null-ls").builtins.formatting.rustfmt,
                require("null-ls").builtins.diagnostics.cppcheck,
            },
        })

        -- Debugging with DAP
        local dap = require("dap")
        require("dapui").setup()

        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "gdb",  -- Use gdb as the command for debugging
            name = "gdb",
        }
dap.configurations.cpp = {
    {
        name = "Launch",
        type = "cppdbg",  -- Will use the "cppdbg" adapter configured above
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        environment = {},
        externalTerminal = false,
    },
}


        -- Testing setup
        vim.cmd([[
            let test#strategy = "neovim"
            let test#cpp#runner = "gtest"
        ]])

        -- Git integration
        require("gitsigns").setup()

        -- File navigation
        require("nvim-tree").setup()

        -- Symbols Outline
        require("symbols-outline").setup()
    end,
}

