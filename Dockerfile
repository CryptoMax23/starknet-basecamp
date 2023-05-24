# Dockerfile

FROM starknet/cairo:1.1.0-alpha0 AS build

FROM python:3.9-alpine

# Aquí se pueden agregar varios programas que se ocuparian para trabajar más cómodos.
RUN apk add --update gmp-dev build-base nodejs npm git zsh curl
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN python -m pip install --upgrade pip

RUN pip3 install ecdsa fastecdsa sympy
RUN pip3 install cairo-lang

ENV STARKNET_NETWORK=alpha-goerli
ENV STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount

COPY --from=build /usr/bin/* /usr/bin/
COPY --from=build /corelib /corelib

ENTRYPOINT [ "sh" ]