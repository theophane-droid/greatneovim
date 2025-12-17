FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data
ENV XDG_CACHE_HOME=/cache
ENV PATH=/usr/local/bin:$PATH

RUN apt update && apt install -y \
    git curl wget ca-certificates \
    ripgrep fd-find unzip \
    python3 python3-pip \
    nodejs npm \
    clangd \
    openjdk-21-jdk \
    rustc cargo \
    build-essential cmake ninja-build gettext \
    libtool libtool-bin pkg-config \
    libx11-dev libxt-dev xclip wl-clipboard \
    openssl \
 && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz \
    | gunzip -c > /usr/local/bin/rust-analyzer \
 && chmod +x /usr/local/bin/rust-analyzer

RUN npm install -g \
    pyright \
    bash-language-server \
    vscode-langservers-extracted \
    typescript \
    typescript-language-server \
    @vue/language-server \
    yaml-language-server \
    dockerfile-language-server-nodejs

RUN pip3 install --break-system-packages python-lsp-server

RUN git clone --depth 1 --branch stable https://github.com/neovim/neovim /tmp/neovim \
 && make -C /tmp/neovim CMAKE_BUILD_TYPE=RelWithDebInfo -j"$(nproc)" \
 && make -C /tmp/neovim install \
 && rm -rf /tmp/neovim

COPY init.lua /config/nvim/init.lua
COPY lua /config/nvim/lua

WORKDIR /workspace
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nvim/site/pack/packer/start \
 && git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /data/nvim/site/pack/packer/start/packer.nvim

RUN wget -qO- https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/keyrings/fury-nushell.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /" | tee /etc/apt/sources.list.d/fury.list
RUN apt -y update
RUN apt -y install nushell

RUN apt -y install socat
RUN printf '%s\n' \
  '#!/bin/sh' \
  'exec socat STDIO,raw,echo=0 UNIX-CONNECT:/host.sock' \
  > /usr/local/bin/hostsh && chmod 0755 /usr/local/bin/hostsh
ENV SHELL=/usr/local/bin/hostsh


RUN nvim --headless \
  -c "autocmd User PackerComplete quitall" \
  -c "PackerSync"


ENTRYPOINT ["/entrypoint.sh"]

