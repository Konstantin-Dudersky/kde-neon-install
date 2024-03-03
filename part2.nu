#!/usr/bin/env nu

# запрос, выполнять ли команду
def ask_for_execution [] {
    mut user_input = "";
    loop {
        $user_input = (input "execute? (y/n) ")
        match $user_input {
            "y" => break,
            "n" => break,
            _ => continue,
        }
    }
    $user_input
}

# обработка одной команды
def process_command [struct] {
    print "------------------------------------------------------------------------------"
    print $struct.prompt
    let ans = (ask_for_execution)
    match $ans {
        "y" => {do $struct.closure},
        "n" => return,
    }
}

# обработка списка команд
def process_list [commands] {
    for $cmd in $commands {
        do -i {process_command $cmd }
    }
}

# ------------------------------------------------------------------------------
# write commands here

let alacritty = {
    prompt: "install alacritty",
    closure: {
        do {
            sudo apt install cmake
            sudo apt install libfontconfig libfontconfig1-dev
            cargo install alacritty
            # находим папку github
            let folders_github = (ls ~/.cargo/registry/src/ | find index.crates.io)
            let folder_github = ($folders_github.0 | get name)
            cd $folder_github
            # находим папку alacritty
            let folders_ala = (ls | find alacritty-)
            let folder_ala = ($folders_ala.0 | get name)
            cd $folder_ala
            # copy icon
            sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
            # install .desktop file
            sudo desktop-file-install extra/linux/Alacritty.desktop
            sudo update-desktop-database
            # copy config
            mkdir ~/.config/alacritty
            cp extra/alacritty.yml ~/.config/alacritty
            # скачиваем темы
            git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
        }
    }
}

let anydesk = {
    prompt: "install Anydesk",
    closure: {
        do {
            wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
            do {
                "deb http://deb.anydesk.com/ all main"
                | sudo tee -a /etc/apt/sources.list.d/anydesk-stable.list
            }
            sudo apt update
            sudo apt install anydesk
        }
    }
}

let appimagelauncher = {
    prompt: "install AppImageLauncher",
    closure: {
        do {
            sudo add-apt-repository ppa:appimagelauncher-team/stable
            sudo apt update
            sudo apt install appimagelauncher
        }
    }
}

let balenaetcher = {
    prompt: "install Balena Etcher",
    closure: {
        do {
            let url = (
                http get https://api.github.com/repos/balena-io/etcher/releases/latest
                | get assets.browser_download_url
                | filter {|x| $x ends-with '_amd64.deb'}
                ).0
            http get --raw $url | save /tmp/etcher.deb
            do -i {sudo dpkg -i /tmp/etcher.deb }
            rm /tmp/etcher.deb
            sudo apt update
            sudo apt --fix-broken install
        }
    }
}

let cargo_tools = {
    prompt: "install cargo tools",
    closure: {
        do { 
            cargo install cargo-update 
            cargo install cargo-workspaces
        }
    }
}

let chromium = {
    prompt: "install Chromium",
    closure: {
        do { sudo snap install chromium }
    }
}

let dbeaver = {
    prompt: "install Dbeaver CE",
    closure: {
        do { sudo snap install dbeaver-ce }
    }
}

let drivers = {
    prompt: "Install additional drivers",
    closure: {
        do {
            sudo apt install software-properties-qt
            sudo software-properties-qt
        }
    }
}

let filezilla = {
    prompt: "install Filezilla",
    closure: {
        do { flatpak install flathub org.filezillaproject.Filezilla }
    }
}

let fira_code = {
    prompt: "install Fira Code",
    closure: {
        do {
            # download
            let url = (
                http get https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest
                | get assets.browser_download_url
                | filter {|x| $x ends-with 'FiraCode.tar.xz'}
                ).0
            http get --raw $url | save /tmp/FiraCode.tar.xz
            mkdir /tmp/FiraCode
            tar -xf /tmp/FiraCode.tar.xz -C /tmp/FiraCode
            cd /tmp/FiraCode
            # install
            sudo mv FiraCodeNerdFont-Regular.ttf /usr/local/share/fonts
            sudo fc-cache -fv
            # clean
            cd ~
            rm /tmp/FiraCode.tar.xz
            rm -rf /tmp/FiraCode
        }
    }
}

let flatpak = {
    prompt: "install Flatpak",
    closure: {
        do { sudo apt install flatpak }
    }
}

let gimp = {
    prompt: "install GIMP",
    closure: {
        do {
            flatpak install https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref
        }
    }
}

let github_desktop = {
    prompt: "install Github Desktop",
    closure: {
        do {
            do {
                wget -qO - https://apt.packages.shiftkey.dev/gpg.key
                | gpg --dearmor
                | sudo tee /usr/share/keyrings/shiftkey-packages.gpg
            }
            do {
                "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main"
                | sudo tee -a /etc/apt/sources.list.d/shiftkey-packages.list
            }
            sudo apt update
            sudo apt install -y github-desktop
        }
    }
}

let inkscape = {
    prompt: "install Inkscape",
    closure: {
        do { flatpak install flathub org.inkscape.Inkscape }
    }
}

let insomnia = {
    prompt: "install Insomnia",
    closure: {
        do { sudo snap install insomnia }
    }
}

let kde_full = {
    prompt: "install kde-full",
    closure: {
        do {sudo apt install kde-full kubuntu-restricted-extras}
    }
}

let libreoffice = {
    prompt: "install Libreoffice",
    closure: {
        do { sudo snap install libreoffice }
    }
}

let lunacy = {
    prompt: "install Lunacy",
    closure: {
        do { sudo snap install lunacy }
    }
}

let mailspring = {
    prompt: "install Mailsping",
    closure: {
        do { sudo snap install mailspring }
    }
}

let nmap = {
    prompt: "install NMap",
    closure: {
        do { sudo apt install -y nmapsi4 }
    }
}

let nodejs = {
    prompt: "install node-js",
    closure: {
        do {
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        }
    }
}

let obsidian = {
    prompt: "install obsidian",
    closure: {
        do { flatpak install flathub md.obsidian.Obsidian }
    }
}

let obs_studio = {
    prompt: "install OBS studio",
    closure: {
        do { flatpak install flathub com.obsproject.Studio }
    }
}

let redisinsight = {
    prompt: "install redisinsight",
    closure: {
        do { sudo snap install redisinsight }
    }
}

let telegram = {
    prompt: "install Telegram",
    closure: {
        do { sudo snap install telegram-desktop }
    }
}

let typora = {
    prompt: "install Typora",
    closure: {
        do { sudo snap install typora }
    }
}

let virt_manager = {
    prompt: "install virt-manager",
    closure: {
        do { sudo apt install -y virt-manager }
    }
}

let virtualbox = {
    prompt: "install VirtualBox",
    closure: {
        do { sudo apt install -y virtualbox }
    }
}

let vscode = {
    prompt: "install VSCode",
    closure: {
        do { sudo snap install code --classic }
    }
}

let yandex_disk = {
    prompt: "install Yandex-Disk",
    closure: {
        do {
            do {
                "deb http://repo.yandex.ru/yandex-disk/deb/ stable main"
                | sudo tee -a /etc/apt/sources.list.d/yandex-disk.list
            }
            do {
                wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O-
                | sudo apt-key add -
            }
            sudo apt update
            sudo apt install -y yandex-disk
        }
    }
}

let yakuake = {
    prompt: "install yakuake",
    closure: {
        do { sudo apt install -y yakuake }
    }
}

let zeal = {
    prompt: "install Zeal",
    closure: {
        do { sudo apt install -y zeal }
    }
}

let zellij = {
    prompt: "install Zellij",
    closure: {
        do { cargo install --locked zellij }
    }
}


let command_list = [
    # begin --------------------------------------------------------------------
    $flatpak
    $kde_full,
    $nodejs,
    # cargo --------------------------------------------------------------------
    $alacritty,
    $cargo_tools
    $zellij,
    # apt ----------------------------------------------------------------------
    $anydesk,
    # $appimagelauncher,
    $balenaetcher,
    $nmap,
    $fira_code,
    $github_desktop,
    $yandex_disk,
    $virt_manager,
    $virtualbox,
    $yakuake,
    $zeal,
    # flatpak ------------------------------------------------------------------
    $filezilla,
    $gimp,
    $inkscape,
    $obs_studio,
    $obsidian,
    # snap ---------------------------------------------------------------------
    $chromium,
    $dbeaver,
    $insomnia,
    $libreoffice,
    $lunacy,
    $mailspring,
    $redisinsight,
    $telegram,
    $typora,
    $vscode,
]

# ------------------------------------------------------------------------------
# запуск обработки
process_list $command_list
