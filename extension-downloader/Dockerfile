FROM redstonewizard/node:17.7.1-ubuntu-impish

ADD . /code

WORKDIR /code
SHELL [ "/bin/bash", "-c" ]

RUN unset $(compgen -v | grep "^YARN_") && \
    yarn cache clean --all && \
    yarn install && \
    yarn format && \
    yarn lint && \
    yarn build

ADD entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/bin/bash", "/docker-entrypoint.sh" ]