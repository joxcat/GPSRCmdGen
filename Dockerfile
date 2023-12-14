FROM mono:6.12
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
    && rm -rf /var/lib/apt/lists/*

# Copy source code
COPY . /build
WORKDIR /build

# Build
RUN make release

# Pack for Linux
RUN for file in bin/Release/*.exe; do \
      mkbundle --simple --static --nodeps \
        -L "$PWD/bin/Release" \
        -z "$file" bin/Release/*.dll \
        -o "$(echo $file | sed 's|.exe|-linux-x64|')" \
        --machine-config /etc/mono/4.5/machine.config \
        --config /etc/mono/config \
    ; done

# Rename for Windows
RUN for file in bin/Release/*.exe; do \
      mv "$file" "$(echo $file | sed -E 's|.exe|-windows.exe|')" \
    ; done
