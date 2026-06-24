return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Move to left pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Move to lower pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Move to upper pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Move to right pane" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Move to previous pane" },
    },
  },
}
