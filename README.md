# ARM64 builds for Tensorflow-Text

At the time of writing, TensorFlow and TensorFlow-Vision are available in
aarch64 builds.  Tensorflow-text is not, but upstream provides scripts which
make building it straightforward.

This repository builds a wheel suitable for use in (at least) a `linux/arm64`
docker container.  No optimisations are provided, and the wheel is built against
the unoptimised cpu build of tensorflow directly from pip.  If you intend to use
this in production you probably want to take a look at the
[official arm dockerfiles](https://github.com/ARM-software/Tool-Solutions/tree/main/docker/tensorflow-aarch64).

We build inside a docker container in emulation (qemu).  This has the downside
of being quite slow (cross compiling with native instructions would probably be
notably faster) but the advantage that the wheel is built in the same
environment it will be used in.  Thus you can simply specify the release
artefact as a source in your `pyproject.toml` and build your aarch64 container
from a suitable multiarch base (e.g. `python:3.10`).  Then when you run `poetry
install` the correct wheel will be pulled down:

```toml
[[tool.poetry.dependencies.tensorflow-text]]
markers = "platform_machine == 'aarch64' and sys_platform != 'darwin'"
url = "https://github.com/Thema-AI/Tensorflow-Text-Arm64/releases/download/v0.0.2/tensorflow_text-2.13.0-cp310-cp310-linux_aarch64.whl"

[[tool.poetry.dependencies.tensorflow-text]]
markers = "platform_machine == 'amd64'"
version = "^2.13.0"
source = "PyPI"
```

Note that you do need the `source = "PyPI"` line or poetry will collapse the
constraints into each other, since the url provides a matching version.
