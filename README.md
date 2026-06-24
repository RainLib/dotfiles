# My Personal dotfiles Managed by chezmoi

This repo contains all my dotfiles managed by [chezmoi](https://github.com/twpayne/chezmoi), Chezmoi manage dotfile start with `dot_` prefix instead of `.`  for example,
the `.zshrc` will be `dot_zshrc` in chezmoi, so if you don't want use chezmoi, just rename the `dot_` config file to real `.` file, you can fork and edit before use it.

## How to Use

1. install [chezmoi](https://github.com/twpayne/chezmoi) first. On macOS:

   ```sh
   brew install chezmoi
   ```

2. fork this repo if you want to manage your own dotfiles. If you just want to use this setup, use this repo directly.
3. for a fresh machine, initialize chezmoi from the repo:

   ```sh
   chezmoi init https://github.com/RainLib/dotfiles.git
   chezmoi apply -v
   ```

4. if you already cloned this repo and want this checkout to become the active chezmoi source, run from the repo root:

   ```sh
   sh scripts/apply.sh
   ```

   For a targeted apply:

   ```sh
   sh scripts/apply.sh ~/.tmux.conf ~/.config/nvim
   ```

   The script always applies with `chezmoi -S "$REPO_DIR"` and writes the current checkout into `~/.config/chezmoi/chezmoi.toml`, so later plain `chezmoi apply -v` uses the same repo.
   For non-interactive runs that should overwrite managed targets without prompting, set `DOTFILES_APPLY_FORCE=1`.

You can also init and apply in one step:

```sh
chezmoi init --apply https://github.com/RainLib/dotfiles.git
```

On macOS, chezmoi will install the command-line and GUI dependencies declared in `.chezmoiscripts`, including Neovim, tmux, iTerm2, Nerd Fonts, ripgrep, fd, tree-sitter-cli, and stylua.

## Neovim / NvChad

Neovim is managed directly by chezmoi under `~/.config/nvim` and uses the NvChad starter structure. The setup keeps NvChad light:

- NvChad defaults
- old Vim core key mappings from this repo
- `christoomey/vim-tmux-navigator`
- light Lua formatting and basic LSP scaffolding

Plugin sync runs once after `chezmoi apply`. If you want to skip it:

```sh
NVCHAD_SYNC_ON_APPLY=0 chezmoi apply -v
```

Manual plugin sync:

```sh
nvim --headless "+Lazy! sync" +qa
```

One-command Neovim config reset:

```sh
chezmoi cd
sh scripts/neovim.sh uninstall
sh scripts/neovim.sh reinstall
```

`uninstall` removes Neovim user config/runtime data:

- `~/.config/nvim`
- `~/.local/share/nvim`
- `~/.local/state/nvim`
- `~/.cache/nvim`

It does not uninstall the Homebrew `neovim` binary.

### iTerm2 / tmux pane navigation

The recommended iTerm2 workflow is to run tmux inside iTerm2. Chezmoi installs iTerm2, tmux, TPM, and tmux plugins on macOS. Neovim and tmux both use `christoomey/vim-tmux-navigator`, so inside iTerm2 + tmux you can move between Neovim splits and tmux panes with:

| Keys | Action |
| --- | --- |
| `Ctrl+h` | left pane |
| `Ctrl+j` | lower pane |
| `Ctrl+k` | upper pane |
| `Ctrl+l` | right pane |
| <code>Ctrl+\</code> | previous pane |

The tmux prefix in this repo is `Ctrl+s`. If tmux plugins are not installed automatically, start tmux and press `Ctrl+s` followed by `I`.

If `chezmoi apply -v ~/.tmux.conf` reports `not managed`, your shell is using a different chezmoi source. From this repo, run:

```sh
sh scripts/apply.sh ~/.tmux.conf ~/.config/nvim
tmux source-file ~/.tmux.conf
```

Then verify:

```sh
tmux show -g prefix
tmux list-keys -T root C-h
```

Expected: `prefix C-s`, and `C-h` should show an `if-shell ... select-pane -L` binding.

Native iTerm2 split panes are not managed here because Neovim cannot detect and cross-navigate them like tmux panes. Use tmux for seamless editor/pane interaction.

If NvChad icons or terminal text show as `?`, your terminal profile is not using a valid Nerd Font. Quit iTerm2 completely, then fix iTerm2 profiles from the chezmoi source directory:

```sh
chezmoi cd
sh scripts/fix-terminal-fonts.sh
```

The script uses `HackNFM-Regular 12`, which is the iTerm2 PostScript font name for `Hack Nerd Font Mono`.

WezTerm, Kitty, Ghostty, and Alacritty are configured to use Nerd Font families from this repo.

## wezterm

I use wezterm as my primary terminal emulator which is super fast, and lua is friendly for configuration.

Screenshot:

<img width="1368" alt="image" src="https://github.com/zhaohongxuan/dotfiles/assets/8613196/595e359d-45ad-4949-926a-d56a19135daa">

### key bindings

Mod Key (macOS):

`SUPER` -> `Command`
`SUPER_REV` -> `Command + Shift`
`LEADER` -> `CTRL+a` 
`OPT` -> `OPT`

#### Pane operations 

| Keys               | Action                             |
| ------------------ | ---------------------------------- |
| `SUPER` + `\`      | Split Horizontal                   |
| `SUPER_REV` + `\|` | Split Vertical                     |
| `SUPER` + `Enter`  | Toggle Pane Zoom                   |
| `SUPER` + `w`      | Close current Pane without confirm |
|                    |                                    |
#### Pane Navigation

`Leader` + `any key`  means  stoke `Leader` first and then the arbitrary key.

| Keys           | Action                    |
| -------------- | ------------------------- |
| `Leader` +`k`  | Move cursor to Up Pane    |
| `Leader` +`j`  | Move cursor to Down Pane  |
| `Leader` +`h`  | Move cursor to Left Pane  |
| `Leader` +`l`  | Move cursor to Right Pane |

#### Pane Resize 

Use `Leader + p` to active Pane Resize Mode

| Keys         | Action                          |
| ------------ | ------------------------------- |
| `k`          | Adjust current Pane Size: Up    |
| `j`          | Adjust current Pane Size: Down  |
| `h`          | Adjust current Pane Size: Left  |
| `l`          | Adjust current Pane Size: Right |
| `ESC` or `q` | Quit Pane Resize Mode           |


#### Tab Operation 

| Keys             | Action                          |
| ---------------- | ------------------------------- |
| `SUPER` + `[`    | Navigate to Previous Tab (Left) |
| `SUPER` +`]`     | Navigate to Next Tab (Right)    |
| `SUPER_REV` +`[` | Move current TAB to previous    |
| `SUPER_REV` +`]` | Move current TAB to next        |

#### Miscellaneous

| Keys                  | Action                                    |
| --------------------- | ----------------------------------------- |
| `SUPER` + `u`         | Show all  url candidates  in current Pane |
| `SUPER` + `p`         | Active Command Palette like VSCode        |
| `SUPER_REV` + `Enter` | Active Copy Mode                          |
| `OPT` + `,`     | Open Wezterm config using nvim in new tab |

## Ideavim

1. if you use chezmoi, simply use `chezmoi apply -v ~/.ideavimrc` to make it take effect, or you can copy `.ideavimrc` to your home directory
2. enable `ideavim plugin` in your Jetbrain IDE like Intellij IDEA or Pycharm etc.
3. you can watch my tutorial video in bilibili to get more information:[ideavim插件的配置和使用](https://www.bilibili.com/video/BV1p541157Va)


## tmux

tmux is managed by chezmoi through `.tmux.conf`. It uses TPM with:

- `tmux-plugins/tpm`
- `catppuccin/tmux`
- `christoomey/vim-tmux-navigator`

The prefix is `Ctrl+s`. Pane movement uses `h`, `j`, `k`, and `l` after the prefix, while Neovim/tmux cross-pane movement uses `Ctrl+h/j/k/l`.

The repo still keeps `.tmux.conf.local` for the older Oh My Tmux setup, but the active tmux entrypoint is `.tmux.conf`.

## karabiner

karabiner/karabiner.json
