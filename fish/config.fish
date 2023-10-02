################################################################################
# Commands to run in interactive sessions only
################################################################################

if status is-interactive
    # Running neofetch when starting, it's super cool!
    if type -q neofetch
       neofetch
    end
end



################################################################################

set fish_greeting ""

# Add suport for "!!", finally!
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end



# # Append to PATH so it includes user's private bin if it exists
# if [ -d "$HOME/.local/bin" ]
    # PATH="$HOME/.local/bin:$PATH"
# end
# 
# # Append to PATH so it includes /usr/sbin if it exists
# if [ -d "/usr/sbin" ]
    # PATH="/usr/sbin:$PATH"
# end
# 
# # Append to PATH so it includes /opt/miktex/bin/ if it exists
# if [ -d "/opt/miktex/bin/" ]
    # PATH="/opt/miktex/bin/:$PATH"
# end

# Make $Path = $PATH. Somehow seems required for Latex Workstop (VSCODE), using MikTex
set Path $PATH

# Set LD_LIBRARY_PATH env var
set LD_LIBRARY_PATH "/lib:/usr/lib:/usr/local/lib"



################################################################################
# Useful aliases
################################################################################

# Replace exa with eza (exa is not maintained anymore)
alias exa='eza'

# Replace ls with eza
alias ls='eza -lha --color=always --group-directories-first --icons'    # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'      # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'      # long format
alias lt='eza -aT --color=always --group-directories-first --icons'     # tree listing
alias l.="eza -a | grep -E '^\.'"                                       # show only dotfiles
alias ip="ip -color"



################################################################################
# Replace some more things with better alternatives using fish abbreviations
# (they make the history much more readable and "config neutral")
################################################################################

# alias cat='bat --style header --style rule --style snip --style changes --style header'
abbr --add cat 'bat'
[ -x /usr/bin/paru ] && abbr --add yay 'paru'

# Fix SSH access with kitty terminal emulator (backspace getting all funky if
# the remote host doesn't have the required dependencies installed)
[ "$TERM" = "xterm-kitty" ] && abbr --add ssh 'TERM=xterm-256color ssh'
[ "$TERM" = "xterm-kitty" ] && abbr --add sudossh 'TERM=xterm-256color sudo ssh'

# My favorite time format for use in ts (from moreutils package)
[ -x /usr/sbin/ts ] && abbr --add ts "ts '%Y-%m-%d %H:%M:%.S |'"



# Common use
# alias grubup="sudo update-grub"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
# alias upd='/usr/bin/update'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'
alias hw='hwinfo --short'                           # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"      # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'  # List amount of -git packages

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -100 | nl"


# My custom personal aliases
alias pm2='npx pm2'

# pyenv stuff
pyenv init - | source

# Ryujinx
alias ryujinx="__GL_THREADED_OPTIMIZATIONS=0 __GL_SYNC_TO_VBLANK=0 gamemoderun DOTNET_EnableAlternateStackCheck=1 GDK_BACKEND=x11 /home/vini/.local/share/Ryujinx/Ryujinx"
