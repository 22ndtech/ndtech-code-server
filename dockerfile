FROM codercom/code-server:3.8.0

#install git, python and pip
RUN sudo apt-get update \
  && sudo apt-get install -y git \
  && sudo apt-get install -y python3 \
  && sudo apt-get install -y python3-pip

RUN \
  # install yp
  sudo pip3 install --upgrade pip \
  && sudo pip3 install yq


# Set the git variables
ENV GITHUB_USER="$GITHUB_USER"
ENV GITHUB_USER_EMAIL="$GITHUB_USER_EMAIL"
ENV GITHUB_TOKEN="$GITHUB_TOKEN"
ENV REPOSITORY_NAME="$REPOSITORY_NAME"
ENV REPOSITORY_URL="$REPOSITORY_URL"

# install krew
RUN echo "installing krew" \
  && ( \
  set -x \
  && cd "$(mktemp -d)" \
  && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" \
  && tar zxvf krew.tar.gz \
  && KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" \
  && "$KREW" install krew \
  ) \
  && sudo apt update \
  && PATH="${KREW_ROOT:-/root/.krew}/bin:$PATH"
ENV PATH="/home/coder/.krew/bin:${PATH}"

# install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
  && sudo mv kubectl /usr/local/bin \
  && sudo chmod +x /usr/local/bin/kubectl

RUN \
  echo "set up alias for kubectl" \
  # set up an alias for kubectl
  && echo "alias k='kubectl'" > ~/.bashrc

# install kubectx and kubens
RUN echo "installing the ctx plugin for kubectl" \
  && kubectl krew install ctx \
  # install ns
  && echo "installing the ns plugin for kubectl" \
  && kubectl krew install ns

ENV GIT_USER_NAME="$GIT_USER_NAME"
ENV GIT_USER_EMAIL="$GIT_USER_EMAIL"
ENV GIT_REPOSITORY_NAME="$GIT_REPOSITORY_NAME"

RUN curl -L https://golang.org/dl/go1.15.5.linux-amd64.tar.gz -o go.tar.gz
RUN tar -xzf go.tar.gz
RUN sudo cp -r go /usr/local
RUN rm -rf go
RUN rm  go.tar.gz
ENV PATH="$PATH:/usr/local/go/bin"
RUN go version

RUN go get -v golang.org/x/tools/gopls
RUN go get -v github.com/go-delve/delve/cmd/dlv

ENV DO_EXTERNAL_DNS_TOKEN=${DO_EXTERNAL_DNS_TOKEN}

# Install flux2
RUN curl -s https://toolkit.fluxcd.io/install.sh | bash

# Install helm3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN rm ./get_helm.sh

# Install tekton
RUN curl -LO https://github.com/tektoncd/cli/releases/download/v0.14.0/tkn_0.14.0_Linux_x86_64.tar.gz
RUN sudo tar xvzf tkn_0.14.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn
RUN sudo ln -s /usr/local/bin/tkn /usr/local/bin/kubectl-tkn

# Install doctl
RUN curl -L https://github.com/digitalocean/doctl/releases/download/v1.54.0/doctl-1.54.0-linux-amd64.tar.gz -o doctl.tar.gz
RUN tar -xvf ./doctl.tar.gz
RUN sudo mv ./doctl /usr/local/bin

COPY ./ndtech-entrypoint.sh /usr/bin/

ENTRYPOINT ["/usr/bin/ndtech-entrypoint.sh"]