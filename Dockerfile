#syntax=docker/dockerfile:1.4

ARG PYTHON_VERSION=3.10
ARG VERSION=v2.13.0

FROM python:${PYTHON_VERSION} as builder
ENV PIP_CACHE_DIR=/var/cache/pip
# Bazelisk is the Bazel installer (Bazel is the build system used by tensorflow).
# Looks like it's another random binary off the internet!  Hurrah!
ARG BAZELISK_VERSION=v1.17.0
RUN <<-EOF
    wget https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux-arm64
    mkdir -p /usr/local/bin || true
    mv bazelisk-linux-arm64 /usr/local/bin/bazel
    chmod +x /usr/local/bin/bazel
EOF
ARG VERSION
RUN --mount=type=cache,target=/var/cache/pip \
    <<-EOF
    pip install tensorflow==${VERSION}
EOF
RUN --mount=type=cache,target=/var/cache/pip \
    <<-EOF
    git clone https://github.com/tensorflow/text.git
    cd text
    git checkout ${VERSION}
    ./oss_scripts/install_bazel.sh
    ./oss_scripts/run_build.sh
EOF

FROM scratch as artifact
ARG VERSION
COPY --from=builder text/*.whl ./
