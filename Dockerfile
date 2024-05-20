FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo

RUN apt update && apt install -y \
    build-essential \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    make \
    zip \
    unzip \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libyaml-dev \
    python3 \
    python3-dev \
    python3-pip \
    gcc \
    tree \
    git \
    libyaml-dev \
    neovim \
    neofetch \
    openssh-server


COPY manage_aslr.sh /usr/local/bin/aslr
RUN chmod +x /usr/local/bin/aslr


RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

RUN eval "$(/root/.pyenv/bin pyenv init --path)"
RUN /root/.pyenv/bin/pyenv install 3.11:latest

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN python3 -m pip install -U pip

RUN apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev

RUN apt update && apt install -y \
    build-essential \
    gdb \
    libssl-dev \
    libffi-dev \
    vim \
    curl \
    wget \
    pkg-config \
    git \
    netcat \
    patchelf \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/0vercl0k/rp/releases/download/v2.1.3/rp-lin-gcc.zip
RUN mv ./rp-lin-gcc.zip /tmp/rp++.zip
RUN unzip /tmp/rp++.zip -d /tmp
RUN cp /tmp/rp-lin /usr/local/bin/rp++
RUN chmod +x /usr/local/bin/rp++

RUN python3 -m pip install pwntools pathlib2 ptrlib

RUN /root/.cargo/bin/cargo install ropr
RUN /root/.cargo/bin/cargo install pwninit
RUN /root/.cargo/bin/cargo install bat
RUN /root/.cargo/bin/cargo install eza

RUN if [ ! -e /root/pwn ]; then mkdir /root/pwn ; fi

RUN if [ ! -e /root/pwn/tools ]; then mkdir /root/pwn/tools ; fi

WORKDIR /root/pwn/tools
RUN git clone https://github.com/longld/peda.git
RUN git clone https://github.com/scwuaptx/Pwngdb.git
RUN git clone https://github.com/pwndbg/pwndbg
# RUN git clone https://github.com/radareorg/radare2

WORKDIR /root/pwn/tools/pwndbg
RUN /root/pwn/tools/pwndbg/setup.sh 
# RUN /root/pwn/tools/radare2/sys/install.sh

COPY ./programs ./pwn/programs

RUN apt install -y fish

RUN mkdir -p /root/.config/fish
RUN /bin/bash -c "if [ -e $HOME/.pyenv ]; then rm -r $HOME/.pyenv ; fi"

RUN echo 'set -x PYENV_ROOT /root/.pyenv' >> /root/.config/fish/config.fish
RUN echo 'set -x PATH  /root/.pyenv/bin $PATH' >> /root/.config/fish/config.fish
RUN echo 'set -x PATH /root/.pyenv/shims $PATH' >> /root/.config/fish/config.fish
RUN echo 'status --is-interactive; and source (pyenv init -|psub)' >> /root/.config/fish/config.f
RUN echo 'set -x PATH /root/.cargo/bin $PATH' >> /root/.config/fish/config.fish

RUN /bin/fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install oh-my-fish/theme-idan && fisher install sujaybokil/fish-gruvbox"
RUN chsh -s /bin/fish
ENV LC_CTYPE C.UTF-8 gdb
RUN echo "set -x LC_CTYPE C.UTF-8" >> /root/.config/fish/config.fish
RUN echo 'alias gdb="gdb -q"' >> /root/.config/fish/config.fish
RUN echo 'alias bat="bat --theme=gruvbox-dark"' >> /root/.config/fish/config.fish
RUN echo 'alias ls="eza"' >> /root/.config/fish/config.fish

RUN mkdir /var/run/sshd
RUN echo 'root:pass' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
COPY ./id_ed25519.pub /root/.ssh/authorized_keys
EXPOSE 2222
WORKDIR /root/pwn/programs

CMD ["/usr/sbin/sshd", "-D"]
