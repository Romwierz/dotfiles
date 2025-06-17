# dotfiles

*dotfiles* managed with [GNU Stow](https://www.gnu.org/software/stow/).

*Stow* is a tool that creates a symlinks to the contents of *packages* from *stow directory* inside *target directory*.

The simplest way to use it is as follows:
- Create `$HOME/dotfiles` directory.
- Move there configuration files in a way it reflects the structure of home directory.  
\- For example file `$HOME/.bashrc` goes into `$HOME/dotfiles/.bashrc` and directory `$HOME/.config/i3` goes into `$HOME/dotfiles/.config/i3`.
- Run `$ stow .` command inside *dotfiles* directory.  
\- The default stow directory is current directory and the default target directory is parent directory.  
\- So it takes the package `.` (which is the current directory and its whole content recursively) and creates a symlinks to all of its elements inside `$HOME`.