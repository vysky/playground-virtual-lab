# docker build --file dockerfile --tag virtual-lab:0.1 .

FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# to resolve dl.google.com/linux/chrome/deb GPG error where public key is no longer available
# https://www.google.com/linuxrepositories/
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# install gpg, apt-transport-https and vim
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends gpg apt-transport-https vim

# install microsoft apt repository and signing key
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
RUN install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
RUN sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
RUN rm -f packages.microsoft.gpg

# install code
RUN apt-get update -y && apt upgrade -y
RUN apt-get install -y --no-install-recommends code

# resolve issue when trying to open vscode via desktop shortcut
RUN useradd -m student
RUN sed -i '/\/usr\/share\/code\/code/ s/$/ --user-data-dir="\/home\/student" --no-sandbox/' /usr/share/applications/code.desktop