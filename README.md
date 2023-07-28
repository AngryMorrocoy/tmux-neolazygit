# Neolazygit

Use [lazygit](https://github.com/jesseduffield/lazygit) and neovim inside
tmux as if they were always meant to be together 😃.

## Crappy demo 🤙

![neolazygit-demo](https://i.imgur.com/OBFzJNk.gif)

## Installation

### Using [TPM](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of *TPM* plugins.

```bash
set -g @plugin 'AngryMorrocoy/tmux-neolazygit'
```

And press **prefix+I** to install it.

### Manual installation

Clone this repo:

```bash
$ git clone https://github.com/AngryMorrocoy/tmux-neolazygit <clone-path>
```

Add this line to your **tmux.conf**

```bash
run-shell <clone-path>/neolazygit.tmux
```

Reload your TMUX environment:

```bash
$ tmux source-file <tmux.conf-path>
```

## Configuration options

### `@open-lazygit`

**Default: G (shift+g)**

Key used to open lazygit.

```bash
set -g @open-lazygit 'G'
```
