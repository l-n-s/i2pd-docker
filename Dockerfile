FROM debian:jessie
#todo: add labels

EXPOSE 7070 4444 4447 7656 2827 7654 7650

# Prepare user and directories
ENV HOME="/home/i2pd"
ENV SRC_DIR="${HOME}/src"
ENV DIST_DIR="${HOME}/dist"

RUN useradd --create-home --home-dir "$HOME" i2pd \
    && mkdir -p "$SRC_DIR" "$DIST_DIR" \
    && chown -R i2pd:i2pd "$HOME"

# Install all required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential git ca-certificates \
        libboost-date-time-dev \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libssl-dev \
        zlib1g-dev

ARG GIT_BRANCH="master"
ENV GIT_BRANCH=${GIT_BRANCH}
ARG GIT_TAG=""
ENV GIT_TAG=${GIT_TAG}

# Build binary from source
# Prepare working directory (copy binary and certificates)
RUN git clone -b "$GIT_BRANCH" https://github.com/PurpleI2P/i2pd.git "$SRC_DIR" \
    && cd "$SRC_DIR" \
    && if [ -n "$GIT_TAG" ]; then git checkout tags/"$GIT_TAG"; fi \
    && make \
    && strip "$SRC_DIR"/i2pd \
    && cp "$SRC_DIR"/i2pd "$DIST_DIR" \
    && cp -R "$SRC_DIR"/contrib/certificates "$DIST_DIR" \
    && apt-get clean && rm -rf "$SRC_DIR" && rm -rf /var/lib/apt/lists/*

USER i2pd
COPY i2pd.conf $DIST_DIR
COPY tunnels.conf $DIST_DIR
WORKDIR $DIST_DIR

ENTRYPOINT ["./i2pd", "--datadir=."]
