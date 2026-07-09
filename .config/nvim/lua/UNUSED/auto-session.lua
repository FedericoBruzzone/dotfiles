return {
    "rmagatti/auto-session",
    config = function()
        local function change_nvim_tree_dir()
            local nvim_tree_api = require('nvim-tree.api')
            nvim_tree_api.tree.open()
            nvim_tree_api.tree.change_root(vim.fn.getcwd())
            nvim_tree_api.tree.reload()
        end

        require("auto-session").setup({
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "~/dev", "~/Downloads", "/" },
            post_restore_cmds = { change_nvim_tree_dir, "NvimTreeOpen" },
            pre_save_cmds = { "NvimTreeClose" },
        })
    end
}
