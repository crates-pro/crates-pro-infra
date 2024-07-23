# buck2-build

buck2-build is a Buck2-powered build/test orchestrator for creates-pro and its plugins.

## Project Goals

1. Build crates-pro and other components individually
2. Run tests for components individually and collectively
3. Deploy and enable rebuilding without service interruption

## Usage

buck2-build provides a build environment for crates-pro. You can use it with VS Code Dev Containers by either building the Docker image locally or using our pre-built image from DockerHub.

#### Option 1: Build the image locally

By default, Dev Containers uses the local `Dockerfile` at the project root to build the image and start the container.

#### Option 2: Use the pre-built image

For better performance on the first run, you can use our pre-built Docker image. To do this, modify the `.devcontainer/devcontainer.json` file as follows:

```diff
  {
      "name": "crates-pro-buck2-build",
-     "dockerFile": "../Dockerfile",
+     "image": "duinomaker/crates-pro-buck2-build:0.1.2",
      "runArgs": [
  ...
```

This change instructs Dev Containers to use the pre-built image instead of building it locally.

## Current Status

We are in the first stage, using Buck2 to build all components. Progress on build targets:

- [X] `crates-pro/crates-pro`
  - [X] crates-pro
  - [X] crates_sync
  - [X] model
  - [X] repo_import
  - [X] tudriver
  - [X] tuplugins/plugin1
  - [X] tuplugins/plugin2
- [X] `crates-pro/performance-benchmark`
  - [X] collector/collector (lib)
  - [X] collector/collector (bin)
  - [X] collector/flamegraph-fake
  - [X] collector/muti-rustc-perf
  - [X] collector/runtime-fake
  - [X] collector/rustc-fake
  - [X] data_manage/manager
- [X] `crates-pro/sensleak-rs`
  - [X] sensleak
  - [X] api
  - [X] scan

## License

buck2-build is licensed under either of

- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

This project includes the following submodules with their respective licenses:

- `crates-pro/crates-pro`: Dual-licensed under Apache-2.0 and MIT
- `crates-pro/performance-benchmark`: Dual-licensed under Apache-2.0 and MIT
- `crates-pro/sensleak-rs`: Licensed under MIT

Please note that while the main project is dual-licensed, the submodules may have different licensing terms. Make sure to comply with the license terms of each submodule when using or distributing this project.
