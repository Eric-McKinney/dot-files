#!/usr/bin/env bash

printf "checking cwd is .dot-files or dot-files..."
if [[ ! "${PWD##*/}" =~ ^\.?dot-files$ ]]
then
    printf "it isn't\n"
    if [[ -d ~/.dot-files ]]
    then
        printf "cd'ing to ~/.dot-files..."
        cd ~/.dot-files && echo "done" || { echo "failed"; exit 1; }
    elif [[ -d ~/dot-files ]]
    then
        printf "cd'ing to ~/dot-files..."
        cd ~/dot-files && echo "done" || { echo "failed"; exit 1; }
    else echo "error: neither ~/.dot-files or ~/dot-files exist"; exit 1
    fi
fi

# files that would work with gnu stow (aka path relative to dot-files/ is same as relative to ~)
# basically almost everything
stowable=(.config/*/* .bash_aliases .bashrc .gitconfig .profile .vimrc)

printf "backing up existing dotfiles...\n"
for file in "${stowable[@]}"
do
    if [[ -f ~/$file ]]
    then
        printf "    backing up ${file##*/}..."
        cp -r ~/"$file" ~/"$file-$(date +%m-%d-%y_%H:%M:%S)".bak && echo "done" || { echo "failed"; exit 1; }
        printf "    removing original ${file##*/}..."
        rm -rf ~/"$file" && echo "done" || { echo "failed"; exit 1; }
    fi
done

echo "checking if required directories exist..."
required_dirs=(.config/*/ .vim/colors/)
dirs_created=0
for dir in "${required_dirs[@]}"
do
    if [[ ! -d ~/$dir ]]
    then
        printf "    missing ~/$dir, creating it..."
        mkdir -p ~/"$dir" && echo "done" || { echo "failed"; exit 1; }
        (( dirs_created++ ))
    fi
done

[[ $dirs_created -eq 0 ]] && printf "\033[1A\033[42Gdone\n"

echo "installing dependencies..."
declare -A prereqs  # keys: directory, values: git repo url
prereqs[".synth-shell-prompt"]="https://github.com/andresgongora/synth-shell-prompt.git"
prereqs[".fzf-git"]="https://github.com/junegunn/fzf-git.sh"

for prereq in "${!prereqs[@]}"
do
    if [[ ! -d ~/$prereq ]]
    then
        printf "    downloading ${prereq##~/.}..."
        git clone --recursive ${prereqs[$prereq]} ~/$prereq > /dev/null 2>&1 && echo "done" || { echo "failed"; exit 1; }
        printf "    installing ${prereq##~/.}..."

        case $prereq in
            ".synth-shell-prompt")
                ~/.synth-shell-prompt/setup.sh <<-HEREDOC > /dev/null 2>&1 && echo "done" || { echo "failed"; exit 1; }
					n
				HEREDOC
                ;;

            ".fzf-git")
                mkdir ~/.config/fzf
                cp ~/.fzf-git/fzf-git.sh ~/.config/fzf && echo "done" || { echo "failed"; exit 1; }
                ;;

            *)
                echo "$prereq has unimplemented installation step!!"
                exit 1
                ;;
        esac
    fi
done

echo "creating symbolic links..."
for file in "${stowable[@]}"
do
    printf "    linking ${file##*/}..."
    ln -fs "${PWD}/$file" ~/"$file" && echo "done" || { echo "failed"; exit 1; }
done

# vim themes don't work as symbolic links :(
# but were you going to edit them anyways?
echo "copying vim themes..."
for theme in .vim/colors/*
do
    : "${theme##*/}"
    : "${_%%.vim}"  # strip all but actual name of theme
    printf "    copying $_..."
    cp "$theme" ~/"$theme" && echo "done" || { echo "failed"; exit 1; }
done

# firefox :/
echo "configuring firefox..."

if [[ ! -f ~/.mozilla/firefox/profiles.ini ]]
then
    echo "    no profile directory detected, creating it..."
    echo "        starting firefox in headless mode..."
    (firefox --headless > /dev/null 2>&1 &)  # subshell to avoid job related output
    (:;:)  # microsleep
    pidof firefox > /dev/null && echo "done" || echo "failed"
    printf "        waiting for profile directory to be created..."

    i=0
    while [[ ! -f ~/.mozilla/firefox/profiles.ini ]]
    do
        if [[ $i -ge 300 ]]
        then
            echo "timed out"
            exit 1
        fi

        sleep 0.1
        printf "."
        (( i++ ))
    done
    sleep 2  # wait a little longer just because
    echo "done"

    printf "        closing firefox..."
    kill $(pidof firefox) && echo "done" || echo "failed"
fi

: "$(grep ".*\.default.*" ~/.mozilla/firefox/profiles.ini)"
firefox_profile_dir=~/.mozilla/firefox/"${_##*=}"  # assume the first match with .default in it is the path to the profile

printf "    creating directories..."
mkdir -p "$firefox_profile_dir"/chrome/img && echo "done" || { echo "failed"; exit 1; }

if [[ -f $firefox_profile_dir/chrome/userContent.css ]]
then
    printf "    backing up userContent.css..."
    cp "$firefox_profile_dir"/chome/userContent.css "$firefox_profile_dir/chrome/userContent.css-$(date +%D_%H:%M:%S)".bak \
        && echo "done" || { echo "failed"; exit 1; }
fi

printf "    linking userContent.css..."
cp -f "${PWD}"/userContent.css "$firefox_profile_dir"/chrome && echo "done" || echo "failed"
printf "    copying wallpaper..."
cp "${PWD}"/wallpapers/moonlight_mountain_purple.jpg "$firefox_profile_dir"/chrome/img && echo "done" || echo "failed"
printf "    enabling custom stylesheets in firefox..."
if [[ -z $(grep "toolkit\.legacyUserProfileCustomizations\.stylesheets" "$firefox_profile_dir"/prefs.js) ]]
then
    printf 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$firefox_profile_dir"/prefs.js \
        && echo "done" || echo "failed"
else
    sed -ri 's/(user_pref\("toolkit.legacyUserProfileCustomizations.stylesheets",).*/\1 true\);/' "$firefox_profile_dir"/prefs.js \
        && echo "done" || echo "failed"
fi

echo
echo "Install complete :)"
