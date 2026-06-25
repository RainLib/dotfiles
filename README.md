# RainLib dotfiles

Personal dotfiles managed by [chezmoi](https://github.com/twpayne/chezmoi).

This repo is intended to be applied directly with chezmoi. Files that should
become dotfiles use chezmoi naming, for example `dot_zshrc` becomes `~/.zshrc`
and `dot_config/nvim` becomes `~/.config/nvim`.

## Feature Checklist

| Area | Status | Notes |
| --- | --- | --- |
| chezmoi source management | Ready | `scripts/apply.sh` makes the current checkout the active chezmoi source. |
| macOS dependency install | Ready | Installs zsh, Neovim, tmux, fzf, ripgrep, fd, Nerd Fonts, iTerm2, WezTerm, Kitty, and related CLI tools. |
| Zsh shell | Ready | Uses Oh My Zsh with `git`, `z`, `vi-mode`, `fzf-tab`, `zsh-autosuggestions`, and `zsh-syntax-highlighting`. |
| Zsh alias picker | Ready | Press `Ctrl-x` then `a` to pick an alias with `fzf` and insert it into the command line. |
| Neovim | Ready | NvChad-based config managed under `~/.config/nvim`. |
| Neovim/tmux navigation | Ready | `Ctrl-h/j/k/l` moves across Neovim splits and tmux panes. |
| tmux | Ready | Managed through `~/.tmux.conf`, with TPM, catppuccin, and vim-tmux-navigator installed by setup scripts. |
| Terminal fonts | Ready | iTerm2 font repair script plus Nerd Font defaults for WezTerm, Kitty, Ghostty, and Alacritty. |
| IdeaVim | Ready | Managed through chezmoi as `~/.ideavimrc`. |
| Linux bootstrap | Partial | The repo prints the required package list; Linux package installation is intentionally left to the distro package manager. |
| Native iTerm2 split navigation | Not supported | Use tmux panes for editor/shell pane navigation. Neovim cannot reliably cross-navigate native iTerm2 panes. |

## Installation and Configuration

### 1. Fresh macOS Machine

Install Homebrew first if it is not available:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then install chezmoi:

```sh
brew install chezmoi
```

Initialize and apply this repo:

```sh
chezmoi init --apply https://github.com/RainLib/dotfiles.git
```

This full apply performs the macOS bootstrap declared in `.chezmoiscripts`:

- installs command-line tools and terminal apps with Homebrew
- installs Oh My Zsh and zsh plugins
- applies `~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim`, terminal configs, and IdeaVim config
- syncs Neovim plugins
- installs tmux plugins
- repairs iTerm2 font settings when possible

Open a new terminal window after the install, or reload zsh:

```sh
source ~/.zshrc
```

### 2. Existing Local Checkout

Use this when the repo has already been cloned and should become the active
chezmoi source:

```sh
cd /path/to/dotfiles
sh scripts/apply.sh
```

After this, regular chezmoi commands use this checkout:

```sh
chezmoi source-path
chezmoi apply -v
```

Expected `chezmoi source-path` output is the path to this repo.

### 3. Preserve Local Shell Configuration

Before applying `~/.zshrc` on an existing machine, move machine-specific SDK,
Conda, Bun, private paths, and secrets into:

```sh
~/.zshrc.local
```

The managed `~/.zshrc` loads that file when it exists, and this repo does not
manage it.

### 4. Apply Individual Modules

Apply only shell config:

```sh
sh scripts/apply.sh ~/.zshrc ~/.chezmoiscripts/120_setup-zsh.sh
source ~/.zshrc
```

Apply only tmux config:

```sh
sh scripts/apply.sh ~/.tmux.conf ~/.chezmoiscripts/300_setup-tmux.sh
tmux source-file ~/.tmux.conf
```

Apply only Neovim config:

```sh
sh scripts/apply.sh ~/.config/nvim ~/.chezmoiscripts/200_setup-nvim.sh
```

Apply terminal font repair only:

```sh
sh scripts/apply.sh ~/.chezmoiscripts/150_setup-terminal-fonts.sh
```

Apply everything non-interactively, useful for automation:

```sh
DOTFILES_APPLY_FORCE=1 sh scripts/apply.sh
```

### 5. Verify Installation

Check chezmoi source:

```sh
chezmoi source-path
```

Check zsh alias picker dependencies:

```sh
command -v fzf
echo $ZSH
```

Check tmux navigation:

```sh
tmux show -g prefix
tmux list-keys -T root C-h
```

Check Neovim mapping:

```sh
nvim --headless --cmd 'set shadafile=NONE' '+lua vim.wait(300)' '+verbose nmap <C-h>' +qa
```

### 6. Daily Usage After Setup

Start the main tmux session:

```sh
tm
```

Open Neovim:

```sh
v
```

Pick and insert a zsh alias:

```text
Ctrl-x, then a
```

## Zsh

The shell config is managed by [dot_zshrc](dot_zshrc). Setup scripts install
Oh My Zsh plus the custom plugins used by the config:

- `zsh-users/zsh-autosuggestions`
- `zsh-users/zsh-syntax-highlighting`
- `Aloxaf/fzf-tab`

Machine-local shell customizations can live in `~/.zshrc.local`. That file is
loaded by `~/.zshrc` when present and is intentionally not managed by this repo.

Useful aliases and functions:

| Command | Action |
| --- | --- |
| `v` | Open Neovim. |
| `ll` | Run `ls -la`. |
| `cm` | Run `chezmoi`. |
| `hh` | Show all loaded aliases and their commands. |
| `cx` | Start Codex with approval disabled and workspace-write sandbox. |
| `cxd` | Start Codex with sandbox and approval bypassed. |
| `tm` | Attach to or create the `main` tmux session. |
| `gs` | Run `git status`. |
| `gp` | Run `git pull --rebase`. |
| `dcup` | Run `docker compose up -d`. |
| `kpods` | Run `kubectl get pods -A`. |
| `dev` | Run `pnpm dev`. |
| `gcf` | Pick a local git branch with `fzf` and check it out. |
| `gcfr` | Pick a remote git branch with `fzf` and check it out locally. |
| `fd` | Pick a directory with `fzf` and `cd` into it. |
| `fh` | Pick a command from shell history and run it. |

Alias picker:

| Keys | Action |
| --- | --- |
| `Ctrl-x`, then `a` | Open an `fzf` alias picker and insert the selected alias name into the current command line. |

Example: press `Ctrl-x a`, choose `cm`, and the prompt receives `cm ` so you can continue typing arguments.

Reload after editing:

```sh
source ~/.zshrc
```

## Neovim

Neovim is managed directly under `~/.config/nvim` and uses NvChad as the base.
The config adds:

- NvChad defaults
- existing personal Vim-style mappings
- `christoomey/vim-tmux-navigator`
- basic LSP scaffolding
- `conform.nvim` with Stylua for Lua formatting

Manual plugin sync:

```sh
nvim --headless "+Lazy! sync" +qa
```

Reset and reinstall Neovim config:

```sh
chezmoi cd
sh scripts/neovim.sh reinstall
```

The reinstall command removes only Neovim user config/runtime data:

- `~/.config/nvim`
- `~/.local/share/nvim`
- `~/.local/state/nvim`
- `~/.cache/nvim`

It does not uninstall the Homebrew `neovim` binary.

## tmux and iTerm2

Use tmux panes inside iTerm2 for reliable editor/shell navigation.

Start or attach to the default session:

```sh
tmux new -A -s main
```

The tmux prefix is `Ctrl-s`.

| Keys | Action |
| --- | --- |
| `Ctrl-h` | Move left across Neovim splits or tmux panes. |
| `Ctrl-j` | Move down across Neovim splits or tmux panes. |
| `Ctrl-k` | Move up across Neovim splits or tmux panes. |
| `Ctrl-l` | Move right across Neovim splits or tmux panes. |
| `Ctrl-\` | Move to the previous tmux pane. |
| `Ctrl-s`, then `\|` or `%` | Split tmux pane horizontally in the current path. |
| `Ctrl-s`, then `-` or `"` | Split tmux pane vertically in the current path. |
| `Ctrl-s`, then `c` | Create a new tmux window in the current path. |
| `Ctrl-s`, then `h/j/k/l` | Move between tmux panes with prefix mode. |
| `Ctrl-s`, then `H/J/K/L` | Resize the current tmux pane. |
| `Ctrl-s`, then `m` | Toggle pane zoom. |
| `Ctrl-s`, then `r` | Reload tmux config. |

Reload tmux config:

```sh
tmux source-file ~/.tmux.conf
```

Verify navigation bindings:

```sh
tmux show -g prefix
tmux list-keys -T root C-h
```

Expected result: `prefix C-s`, and `C-h` should include an `if-shell ... select-pane -L` binding.

## Terminal Fonts

macOS setup installs Nerd Fonts and attempts to update iTerm2 profiles. If icons
show as `?`, quit iTerm2 completely and run:

```sh
chezmoi cd
sh scripts/fix-terminal-fonts.sh
```

The script uses `HackNFM-Regular 12`, the iTerm2 PostScript name for Hack Nerd
Font Mono.

## Other Terminal Configs

This repo also manages terminal configs for:

- WezTerm
- Kitty
- Ghostty
- Alacritty

WezTerm currently uses a Nerd Font fallback stack:

- Hack Nerd Font Mono
- JetBrainsMono Nerd Font
- DroidSansM Nerd Font
- Apple Color Emoji

## IdeaVim

Apply IdeaVim config with:

```sh
chezmoi apply -v ~/.ideavimrc
```

Then enable the IdeaVim plugin in JetBrains IDEs.

## Troubleshooting

If a target reports `not managed`, your shell is probably using a different
chezmoi source. From this repo, run:

```sh
sh scripts/apply.sh ~/.config/chezmoi/chezmoi.toml
chezmoi source-path
```

If tmux navigation does not move anywhere, first make sure there is more than
one tmux pane:

```sh
tmux split-window -h
```

If Neovim was already open before applying this config, restart Neovim or run:

```vim
:lua dofile(vim.fn.stdpath("config") .. "/lua/mappings.lua")
```

If zsh alias picking does not open, verify `fzf` is installed and reload zsh:

```sh
command -v fzf
source ~/.zshrc
```

If machine-specific shell paths, SDKs, or secrets are needed, put them in:

```sh
~/.zshrc.local
```

## Function Coverage

For the current scope of this dotfiles repo, the core functionality is covered:
chezmoi bootstrap, zsh aliases and plugins, alias insertion shortcut, Neovim,
tmux navigation, terminal fonts, and macOS terminal tooling.

The remaining intentional gaps are:

- Linux package installation is not automated across package managers.
- Native iTerm2 panes are not integrated with Neovim navigation; tmux panes are the supported workflow.
- Machine-specific SDK paths, private tokens, and local-only shell setup are not committed; keep them in `~/.zshrc.local`.
