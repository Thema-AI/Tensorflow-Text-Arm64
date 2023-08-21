# ARM64 builds for Tensorflow-Text

At the time of writing, TensorFlow and TensorFlow-Vision are available in
aarch64 builds.  Tensorflow-text is not, but upstream provides scripts which
make building it relatively painless.

This repository builds a wheel suitable for use in (at least) a `linux/arm64`
docker container.  No optimisations are provided, and the wheel is built against
the unoptimised cpu build of tensorflow directly from pip.  If you intend to use
this in production you probably want to take a look at the
[official arm dockerfiles](https://github.com/ARM-software/Tool-Solutions/tree/main/docker/tensorflow-aarch64).
