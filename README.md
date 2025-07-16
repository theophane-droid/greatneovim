# VS Code is Dead – A Personal **Neovim** Configuration

Want a simple yet usable Neovim setup? You’re in the right place.

## Installation on Debian-like Systems

On an up-to-date system, run:

```bash
git clone https://github.com/theophane-droid/greatneovim
chmod +x install.sh
./install.sh
````

# Updating to the Latest Version

Simply run:

```bash
./install.sh
```

## Mouse Copy-Paste

To enable mouse-based copy-paste, you need an X session.
This can work either through a local graphical session or via SSH with X11 forwarding enabled:

```
ssh -X user@host
```

MobaXterm works as an X11 client, but PuTTY does not.

## Tmux conf

Append this at the end of the `~/.tmux/conf` file : 

```
set-option -sa terminal-overrides ',*:Tc'
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -g mouse on

bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -i"

# add vim like shortcuts
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
```

# Rebuild an AppImage distribution

```
chmod +x ./build.sh
./build.sh
```
