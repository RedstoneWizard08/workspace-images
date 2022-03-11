#!/bin/sh

install_debian () {
    DPKG_ARCH="$(dpkg --print-architecture)"

    apt-get update
    apt-get -y upgrade
    apt-get -y install bash curl git tar xz-utils libatomic1 gnupg

    echo "Checking CPU architecture..."
    case "${DPKG_ARCH}" in
        arm64) export NODE_ARCH="arm64" ;;
        armhf) export NODE_ARCH="armv7l" ;;
        ppc64el) export NODE_ARCH="ppc64le" ;;
        s390x) export NODE_ARCH="s390x" ;;
        amd64) export NODE_ARCH="x64" ;;
        *) { echo "Unsupported architecture. Exiting..."; exit 1; } ;; esac
    
    echo "Downloading node..."
    curl -fsSLo "/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}" \
    "${NODE_DOWNLOAD_PREFIX}${NODE_VERSION}${NODE_DOWNLOAD_MID}${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}"

    echo "Checking signature..."
    curl -fsSLo "/${NODE_SHA265SUMS_FILE_SHA}" "${NODE_DOWNLOAD_PREFIX}${NODE_VERSION}${NODE_DOWNLOAD_MID}${NODE_SHA265SUMS_FILE_SHA}"
    gpg --batch --decrypt --output "/${NODE_SHA256SUMS_FILE}" "/${NODE_SHA265SUMS_FILE_SHA}"
    grep " ${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}\$" "${NODE_SHA256SUMS_FILE}" | sha256sum -c -
    rm "${NODE_SHA256SUMS_FILE}"
    rm "${NODE_SHA265SUMS_FILE_SHA}"

    if [ -d "${NODE_DIRECTORY}" ]; then { echo "Removing old install..."; rm -r "${NODE_DIRECTORY}"; }; fi

    echo "Creating directories..."
    mkdir -p "${NODE_DIRECTORY}"

    echo "Extracting node..."
    tar ${NODE_TAR_FLAGS} "/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}" -C "${NODE_DIRECTORY}"

    echo "Cleaning up..."
    rm "/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}"
    mv -v ${NODE_DIRECTORY}/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}/* "${NODE_DIRECTORY}"
    rmdir "${NODE_DIRECTORY}/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}"
    if [ -d "/usr/local/bin" ]; then { echo "Removing old local bin..."; rm -r "/usr/local/bin"; }; fi

    echo "Creating symlinks..."
    ln -s "${NODE_DIRECTORY}/bin" "/usr/local/bin"

    echo "Installing dependencies..."
    npm install --global yarn@latest npm@latest
    
    echo "Checking versions..."
    node -v
    npm -v
    yarn -v
    
    echo "All done!"
    exit 0
}

install_alpine () {
    apk update
    apk upgrade
    apk add --no-cache curl bash git tar xz coreutils libc6-compat protobuf gcompat gnupg

    APK_ARCH="$(arch)"

    echo "Checking CPU architecture..."
    case "${APK_ARCH}" in
        aarch64) export NODE_ARCH="arm64" ;;
        armv7l) export NODE_ARCH="armv7l" ;;
        ppc64le) export NODE_ARCH="ppc64le" ;;
        s390x) export NODE_ARCH="s390x" ;;
        x86_64) export NODE_ARCH="x64" ;;
        *) { echo "Unsupported architecture. Exiting..."; exit 1; } ;; esac
    
    echo "Downloading node..."
    curl -fsSLo "/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}" \
    "${NODE_DOWNLOAD_PREFIX}${NODE_VERSION}${NODE_DOWNLOAD_MID}${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}"

    echo "Checking signature..."
    curl -fsSLo "/${NODE_SHA265SUMS_FILE_SHA}" "${NODE_DOWNLOAD_PREFIX}${NODE_VERSION}${NODE_DOWNLOAD_MID}${NODE_SHA265SUMS_FILE_SHA}"
    gpg --batch --decrypt --output "/${NODE_SHA256SUMS_FILE}" "/${NODE_SHA265SUMS_FILE_SHA}"
    grep " ${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}\$" "${NODE_SHA256SUMS_FILE}" | sha256sum -c -
    rm "${NODE_SHA256SUMS_FILE}"
    rm "${NODE_SHA265SUMS_FILE_SHA}"

    if [ -d "${NODE_DIRECTORY}" ]; then { echo "Removing old install..."; rm -r "${NODE_DIRECTORY}"; }; fi

    echo "Creating directories..."
    mkdir -p "${NODE_DIRECTORY}"

    echo "Extracting node..."
    tar ${NODE_TAR_FLAGS} "/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}" -C "${NODE_DIRECTORY}"

    echo "Cleaning up..."
    rm "/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}${NODE_PACKAGE_SUFFIX}"
    mv -v ${NODE_DIRECTORY}/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}/* "${NODE_DIRECTORY}"
    rmdir "${NODE_DIRECTORY}/${NODE_PACKAGE_PREFIX}${NODE_VERSION}${NODE_PACKAGE_MID}${NODE_ARCH}"
    if [ -d "/usr/local/bin" ]; then { echo "Removing old local bin..."; rm -r "/usr/local/bin"; }; fi

    echo "Creating symlinks..."
    ln -s "${NODE_DIRECTORY}/bin" "/usr/local/bin"

    echo "Installing dependencies..."
    npm install --global npm@latest
    
    echo "Downloading Yarn..."
    curl -fsSLo "/yarn.tar.gz" "${YARN_DOWNLOAD_PREFIX}${YARN_VERSION}${YARN_DOWNLOAD_MID}${YARN_VERSION}${YARN_DOWNLOAD_SUFFIX}"
    curl -fsSLo "/yarn.tar.gz.${YARN_SHASUM_EXT}" "${YARN_DOWNLOAD_PREFIX}${YARN_VERSION}${YARN_DOWNLOAD_MID}${YARN_VERSION}${YARN_DOWNLOAD_SUFFIX}.${YARN_SHASUM_EXT}"

    echo "Checking signature..."
    gpg --batch --verify "/yarn.tar.gz.${YARN_SHASUM_EXT}" "/yarn.tar.gz"
    rm "/yarn.tar.gz.${YARN_SHASUM_EXT}"

    echo "Checking directories..."
    if [ ! -d "${YARN_INSTALL_BASE_DIR}" ]; then mkdir -p "${YARN_INSTALL_BASE_DIR}"; fi

    echo "Extracting Yarn..."
    tar ${YARN_TAR_FLAGS} "/yarn.tar.gz" -C "${YARN_INSTALL_BASE_DIR}"
    mv "${YARN_INSTALL_BASE_DIR}/yarn-v${YARN_VERSION}" "${YARN_INSTALL_DIR}"

    echo "Creating symlinks..."
    ln -s "${YARN_INSTALL_DIR}/bin/yarn" "/usr/local/bin/yarn"
    ln -s "${YARN_INSTALL_DIR}/bin/yarnpkg" "/usr/local/bin/yarnpkg"

    echo "Checking versions..."
    node -v
    npm -v
    yarn -v
    
    echo "All done!"
    exit 0
}

check_os () {
    RELEASE="$(cat /etc/*-release | grep '^ID=')"
    if [ "$RELEASE" = "ID=ubuntu" ] || [ "$RELEASE" = "ID=debian" ]; then
        install_debian
        exit 0
    elif [ "$RELEASE" = "ID=alpine" ]; then
        install_alpine
        exit 0
    else
        echo "Unsupported OS."
        exit 1
    fi
}

check_os