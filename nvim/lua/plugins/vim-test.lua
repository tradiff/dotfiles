-- unit tests
return {
  "vim-test/vim-test",
  dependencies = { "preservim/vimux" },
  config = function()
    vim.g["test#neovim#start_normal"] = 1
    vim.g["test#preserve_screen"] = 0
    vim.g["test#strategy"] = "vimux"
    vim.g["shtuff_receiver"] = "vim-test"

    vim.g.VimuxOrientation = "h"
    vim.g.VimuxHeight = "30"

    vim.keymap.set("n", "<leader>t", ":wa<CR>:TestNearest<CR>", { noremap = true, })
    vim.keymap.set("n", "<leader>l", ":wa<CR>:TestLast<CR>", { noremap = true, })

    vim.g["test#go#gotest#executable"] = "gotestsum --"
  end,
}
