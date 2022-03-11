# Base Node.js 16 image
FROM redstonewizard/node:16.14.0-ubuntu-impish as vscode

# VS Code variables
ENV VSCODE_PATH=/usr/lib/vscode
ENV VSCODE_EXTENSION_PATH="${VSCODE_PATH}/extensions"

# Use bash
SHELL [ "/bin/bash", "-c" ]

# Clone the repository
RUN git clone https://github.com/RedstoneWizard08/vscode-test-web.git "${VSCODE_PATH}" && \
    cd "${VSCODE_PATH}" && \
    # Install dependencies
    yarn install && \
    # Install built-in extensions
    yarn install-extensions && \
    # Compile it
    yarn compile && \
    # Download VS Code
    node . --downloadOnly true --quality stable

# Set working directory
WORKDIR "/usr/lib/vscode"

# Set entrypoint
ENTRYPOINT [ "/usr/local/bin/node", "/usr/lib/vscode", "--host", \
      "0.0.0.0", "--port", "3000", "--headless", "--browser", "none", \
      "--quality", "stable", "--printServerLog", "true", "--extensionPath", \
      "/usr/lib/vscode/extensions" ]

# Download extensions
FROM redstonewizard/vscode-extdownloader:latest as extensions

# Unset yarn (build-time) variables because they suck (and break yarn, also I don't know how to remove them during build :p)
RUN unset $(compgen -v | grep "^YARN_") && \
    # Download and extract extensions
    yarn start:dev

# Back to our vscode image
FROM vscode

# Copy all the extensions
COPY --from=extensions /code/extensions /usr/lib/vscode/extensions