# dotfiles

Configuration files. Use GNU stow to manage symlinks.

1. Clone into ~ (i.e. `~/dotfiles`). GNU stow uses the parent directory as the default target. If elsewhere, use `stow -t ~ <dirs>`
2. Run `stow <dirs>` where `<dirs>` is a list of the directories you want to create symlinks for. (e.g. `stow bash git nvim`)

If a directory structure changes, run `stow -R <dir>`.
