Config files for hopefully-installed-on-default programs to improve usage of someone else's PC.

To use it, create a directory ~/.custom-config and put there all the files. Then source the `profile`
so the changes take place for the current shell session.

Automate environment configuration by sourcing the `profile` in shell's rc file:  
`$ echo '. ~/.custom-config/profile' >> ~/.bashrc` (example for bash).

Download into the correct directory:  
```
dest=~/.custom-config
mkdir -p $dest
(
    cd $dest
    for url in $(curl -s https://api.github.com/repos/Romwierz/dotfiles/contents/.local/share/fix-this-distro \
        | jq -r '.[] | select(.type=="file") | .download_url'); do
        wget $url
    done
)
unset dest
```
