ARG VARIANT=bookworm
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Pacotes do sistema
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
      clang \
      python3-venv \
      udev \
      pip \
      gdb \
      cppcheck \
      less \
      git \
      procps \
      sudo \
      fzf \
      zsh \
      man-db \
      unzip \
      gnupg2 \
      gh \
      iptables \
      ipset \
      iproute2 \
      dnsutils \
      aggregate \
      jq \
      wget \
      clang-format \
      clangd \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# git-delta (diffs com destaque de sintaxe no CLI)
ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) \
 && wget -q "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" \
 && dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" \
 && rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Regras udev para o PlatformIO
RUN curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules \
      | tee /etc/udev/rules.d/99-platformio-udev.rules
RUN service udev restart

# Compatibilidade opcional com host Fedora
ARG FEDORA_COMPAT=0

# Cria usuário non-root com o UID/GID do host
# Se o UID/GID já existir na imagem base, remove-o primeiro
RUN if id -u $USER_UID 2>/dev/null; then \
      userdel -f $(id -un $USER_UID); \
    fi; \
    if getent group $USER_GID 2>/dev/null; then \
      groupdel $(getent group $USER_GID | cut -d: -f1); \
    fi; \
    groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
 && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
 && chmod 0440 /etc/sudoers.d/$USERNAME

RUN usermod -a -G dialout $USERNAME
RUN usermod -a -G plugdev $USERNAME

RUN if [ "$FEDORA_COMPAT" = "1" ]; then \
      groupadd -g 18 compat_dialout; \
      usermod -a -G compat_dialout $USERNAME; \
    fi

# Diretório de histórico do shell persistente (respaldado por um volume Docker nomeado)
RUN mkdir -p /home/$USERNAME/.history \
 && touch /home/$USERNAME/.history/.bash_history \
 && touch /home/$USERNAME/.history/.zsh_history \
 && chown -R $USERNAME:$USERNAME /home/$USERNAME/.history

# Workspace
RUN mkdir -p /workspace \
  && chown -R $USERNAME:$USERNAME /workspace

# Variáveis de ambiente
ENV DEVCONTAINER=true
ENV SHELL=/bin/zsh
ENV EDITOR=nano
ENV VISUAL=nano
ENV PATH=$PATH:/home/${USERNAME}/.platformio/penv/bin

WORKDIR /workspace
# Expõe o PATH do PlatformIO para todos os usuários (incluindo root) via profile.d
RUN mkdir -p /etc/profile.d \
 && echo 'export PATH="$PATH:/home/'$USERNAME'/.platformio/penv/bin"' > /etc/profile.d/platformio.sh \
 && chmod +r /etc/profile.d/platformio.sh

# Troca para o usuário non-root para instalações em nível de usuário
USER $USERNAME

# zsh via zsh-in-docker
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
      -t clean \
      -p git \
      -p fzf \
      -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
      -a "source /usr/share/doc/fzf/examples/completion.zsh" \
      -a "export HISTFILE=/home/$USERNAME/.history/.bash_history" \
      -x

# CLI do PlatformIO
RUN curl -fsSL -o /tmp/get-platformio.py \
      https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py \
 && python3 /tmp/get-platformio.py

RUN $HOME/.platformio/penv/bin/pip install flawfinder lizard bitproto pyserial ruff

# Baixa a toolchain + venv do IDF. Sem isso, o PIO Home e o primeiro `pio run`
# disputam o `_create_venv` do espidf.py (rm -rf + recriação); o que terminar
# primeiro é desfeito pelo outro.
RUN mkdir -p /tmp/pio-warmup/src \
 && printf '%s\n' 'extern "C" void app_main(void) {}' > /tmp/pio-warmup/src/main.cpp \
 && printf '%s\n' '[platformio]' 'default_envs = esp32dev' '' '[env:esp32dev]' \
        'platform = espressif32@6.13.0' 'framework = espidf' 'board = esp32dev' \
        > /tmp/pio-warmup/platformio.ini \
 && cd /tmp/pio-warmup \
 && $HOME/.platformio/penv/bin/pio run \
 && rm -rf /tmp/pio-warmup

RUN echo 'export PATH="$HOME/.platformio/penv/bin:$PATH"' \
      | tee -a /home/$USERNAME/.bashrc /home/$USERNAME/.zshrc

# Configura o zsh para usar o arquivo de histórico compartilhado no volume persistente
RUN echo "export HISTFILE=/home/$USERNAME/.history/.bash_history" >> /home/$USERNAME/.zshrc \
 && echo "export HISTSIZE=10000" >> /home/$USERNAME/.zshrc \
 && echo "export SAVEHIST=10000" >> /home/$USERNAME/.zshrc \
 && echo "setopt APPEND_HISTORY" >> /home/$USERNAME/.zshrc \
 && echo "setopt INC_APPEND_HISTORY" >> /home/$USERNAME/.zshrc \
 && echo "setopt SHARE_HISTORY" >> /home/$USERNAME/.zshrc

USER $USERNAME
