FROM ubuntu:22.04

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list 
RUN apt -y update
RUN apt -y full-upgrade
RUN apt -y autoremove
RUN apt -y install git curl sudo
RUN apt autoremove -y

ARG USERNAME=usuyuki
ARG GROUPNAME=usuyuki
ARG UID=1000
ARG GID=1000
ARG PASSWORD=a
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/

# .dotfiles
RUN eval "$(curl -L raw.githubusercontent.com/Usuyuki/.dotfiles/main/components/independency/init.sh)"
# シンボリックリンク貼る
RUN sh ~/.dotfiles/components/linux/common/link.sh



# 変わらないことは上で済ませる(キャッシュ効かせるためにneovim関連の変わりそうなことはこの下でやる)
RUN sudo apt install -y neovim 
