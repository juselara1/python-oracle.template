# neovim builder
FROM oraclelinux:{{ cookiecutter.oracle_version }} AS nvim_build
RUN dnf config-manager --enable ol9_codeready_builder
RUN dnf update
RUN dnf install git ninja-build cmake gcc make gettext curl glibc-gconv-extra -y
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim --depth 1 --branch v0.10.3 \
	&& cd /tmp/neovim \
	&& make install

# fzf builder
FROM oraclelinux:{{ cookiecutter.oracle_version }} AS fzf_build
RUN dnf install git -y
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
RUN /root/.fzf/install --bin
RUN mv /root/.fzf/bin/fzf /usr/local/bin/fzf

# starship builder
FROM oraclelinux:{{ cookiecutter.oracle_version }} AS starship_build
RUN curl -sS https://starship.rs/install.sh > install.sh && chmod +x install.sh
RUN ./install.sh --yes

# zoxide builder
FROM oraclelinux:{{ cookiecutter.oracle_version }} AS zoxide_build
RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# chezmoi builder
FROM oraclelinux:{{ cookiecutter.oracle_version }} AS chezmoi_build
RUN sh -c "$(curl -fsLS get.chezmoi.io)"

# main image
FROM oraclelinux:{{ cookiecutter.oracle_version }}
ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
ARG DOTFILES_REPO
ARG DOTFILES_BRANCH

COPY --from=nvim_build /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=nvim_build /usr/local/share/nvim /usr/local/share/nvim
COPY --from=fzf_build /usr/local/bin/fzf /usr/local/bin/fzf
COPY --from=starship_build /usr/local/bin/starship /usr/local/bin/starship
COPY --from=zoxide_build /root/.local/bin/zoxide /usr/local/bin/zoxide
COPY --from=chezmoi_build /bin/chezmoi /usr/local/bin/chezmoi

RUN dnf install git tmux libffi-devel zlib-devel bzip2-devel readline-devel \
	sqlite-devel wget curl llvm ncurses-devel openssl-devel lzma-sdk-devel \
	libyaml-devel redhat-rpm-config -y

# Replicate the host user.
RUN groupadd -g ${GROUP_ID} ${USER_NAME} \
	&& useradd -l -s "/bin/bash" -u ${USER_ID} -g ${USER_NAME} ${USER_NAME} \
	&& install -d -m 0755 -o ${USER_NAME} -g ${USER_NAME} "/home/${USER_NAME}" \
	&& chown --changes --silent --no-dereference --recursive --from=33:33 \
		"${USER_ID}:${GROUP_ID}" "/home/${USER_NAME}"
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/project

# Install pyenv
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git "/home/${USER_NAME}/.pyenv"
ENV PYENV_ROOT="/home/${USER_NAME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
RUN pyenv install {{ cookiecutter.python_version }}
RUN pyenv global {{ cookiecutter.python_version }}
RUN pip install uv

# Dotfiles setup
RUN chezmoi init --apply --depth=1 --branch=${DOTFILES_BRANCH} ${DOTFILES_REPO}
