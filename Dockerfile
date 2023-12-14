FROM mono:6.12 as builder
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
    && rm -rf /var/lib/apt/lists/*

# Copy source code
COPY . /build
WORKDIR /build

# Build
RUN make release

FROM mono:6.12 as gpsr
WORKDIR /app
COPY --from=builder /build/bin/Release/GPSRCmdGen.exe /build/bin/Release/*.dll /app/
ENTRYPOINT [ "/usr/bin/mono", "/app/GPSRCmdGen.exe" ]

FROM mono:6.12 as egpsr
WORKDIR /app
COPY --from=builder /build/bin/Release/EGPSRCmdGen.exe /build/bin/Release/*.dll /app/
ENTRYPOINT [ "/usr/bin/mono", "/app/EGPSRCmdGen.exe" ]