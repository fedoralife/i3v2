-- Import the image_preview configuration (make sure it's placed before neo-tree)
require('image_preview')

-- Setup neo-tree with the relevant configuration
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- Key mappings for neo-tree
        vim.keymap.set("n", "<leader>nh", ":Neotree filesystem reveal left<CR>", {})
        vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

        -- Custom function for opening image preview in neo-tree
        local function preview_image_from_neo_tree(state)
            local node = state.tree:get_node()
            if node.type == "file" then
                -- If the selected file is an image, preview it
                require("image_preview").PreviewImage(node.path)
            end
        end

        -- Add the custom command to neo-tree commands
        require("neo-tree").setup({
            filesystem = {
                window = {
                    mappings = {
                        ["<leader>p"] = preview_image_from_neo_tree,  -- Map key to preview image
                    },
                },
            },
        })
    end,
}

