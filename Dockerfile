FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo

RUN apt update
RUN apt install -y
RUN apt install build-essential -y
RUN apt install ca-certificates -y
RUN apt install libssl-dev -y
RUN apt install zlib1g-dev -y
RUN apt install libbz2-dev -y
RUN apt install libreadline-dev -y
RUN apt install libsqlite3-dev -y
RUN apt install wget -y
RUN apt install curl -y
RUN apt install llvm -y
RUN apt install make -y
RUN apt install zip -y
RUN apt install unzip -y
RUN apt install libncurses5-dev -y
RUN apt install libncursesw5-dev -y
RUN apt install xz-utils -y
RUN apt install tk-dev -y
RUN apt install libxml2-dev -y
RUN apt install libxmlsec1-dev -y
RUN apt install libffi-dev -y
RUN apt install liblzma-dev -y
RUN apt install libyaml-dev -y
RUN apt install python3 -y
RUN apt install python3-dev -y
RUN apt install python3-pip -y
RUN apt install gcc -y
RUN apt install tree -y
RUN apt install git -y
RUN apt install libyaml-dev -y
RUN apt install neovim -y
RUN apt install neofetch -y
RUN apt install openssh-server -y
RUN apt install fish -y
RUN apt install patchelf -y
RUN apt install elfutils -y

RUN mkdir /root/tools
RUN mkdir /root/workspace
RUN mkdir -p /root/.config/fish

# aslr
COPY manage_aslr.sh /usr/local/bin/aslr
RUN chmod +x /usr/local/bin/aslr

# pyenv
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
RUN echo 'set -x PYENV_ROOT /root/.pyenv' >> /root/.config/fish/config.fish
RUN echo 'set -x PATH  /root/.pyenv/bin $PATH' >> /root/.config/fish/config.fish
RUN echo 'set -x PATH /root/.pyenv/shims $PATH' >> /root/.config/fish/config.fish
# RUN eval "$(/root/.pyenv/bin pyenv init --path)"
RUN /root/.pyenv/bin/pyenv install pypy3.9-7.3.16
RUN /root/.pyenv/bin/pyenv global pypy3.9-7.3.16
# RUN echo 'status --is-interactive; and source (pyenv init -|psub)' >> /root/.config/fish/config.fish

# python libraries
RUN /root/.pyenv/shims/pip install ptrlib
RUN /root/.pyenv/shims/pip install pwntools

# rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN echo 'set -x PATH /root/.cargo/bin $PATH' >> /root/.config/fish/config.fish

# ropr
RUN /root/.cargo/bin/cargo install ropr

# bat
RUN /root/.cargo/bin/cargo install bat
RUN echo 'alias bat="bat --theme=gruvbox-dark"' >> /root/.config/fish/config.fish

# eza
RUN /root/.cargo/bin/cargo install eza
RUN echo 'alias ls="eza"' >> /root/.config/fish/config.fish

# ptr
COPY ./ptr /usr/local/bin/ptr
RUN chmod +x /usr/local/bin/ptr

# pwndbg
WORKDIR /root/tools
RUN git clone https://github.com/pwndbg/pwndbg
WORKDIR /root/tools/pwndbg
RUN ./setup.sh

# pwninit
RUN /root/.cargo/bin/cargo install pwninit
COPY ./pwninit.template.py /root/.config/
RUN echo 'alias pwninit="pwninit --template-path /root/.config/pwninit.template.py"' >> /root/.config/fish/config.fish

# gdb
RUN echo 'alias gdb="gdb -q"' >> /root/.config/fish/config.fish

# fish
RUN /bin/fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install oh-my-fish/theme-idan && fisher install sujaybokil/fish-gruvbox"
RUN chsh -s /bin/fish
# ENV LC_CTYPE C.UTF-8 gdb
RUN echo "set -x LC_CTYPE C.UTF-8" >> /root/.config/fish/config.fish

# programs
COPY ./programs /root/workspace

WORKDIR /root/workspace
