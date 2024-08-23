# Remote Execution

This folder manages the configuration and deployment files for the NativeLink Remote Execution service, which provides build service for Buck2 clients.

## Usage

To use Buck2 in combination with NativeLink, follow these steps:

### Step 1: Deploy NativeLink Locally

To deploy NativeLink on your own machine:

1. Clone the `crates-pro/crates-pro-infra` repository and navigate to this directory.
2. Build and run a Docker image for NativeLink:

```bash
docker build -t my-nativelink .
docker run -p 50051:50051 my-nativelink
```

NativeLink will now be serving at `localhost:50051` via gRPC, ready for Buck2 clients to connect.

### Step 2: Connect Buck2 to NativeLink

Modify the `.buckconfig` file in the project root:

```ini
[buck2_re_client]
  action_cache_address = grpc://localhost:50051
  engine_address = grpc://localhost:50051
  cas_address = grpc://localhost:50051
  tls = false
  instance_name = main
```

This configuration connects Buck2 to your local NativeLink deployment.

## Maintenance

You may need to update the Remote Execution setup in this folder when:

- Your code requires new build dependencies
- You want to optimize the Remote Execution deployment on the Crates Pro infrastructure

### Adding Build Dependencies

To add new build dependencies, toolchains, or pre-download resources for the Crates Pro build process:

1. Edit `./Dockerfile` in this folder.
2. Add instructions to set up the required build dependency.
3. Rebuild the Docker image:

   ```bash
   docker build -t my-nativelink .
   ```

### Configuring NativeLink

NativeLink uses a JSON configuration file. Currently, we use `./basic_cas.json`, which sets up:

- Build action scheduler
- A single build worker
- Action cache
- Build artifact storage (CAS)

All these components run within a single container. (We plan to scale the deployment with 20+ workers in separate containers in the future.)

To modify the configuration:

1. Refer to the [NativeLink Configuration Introduction](https://docs.nativelink.com/config/configuration-intro/).
2. Update the `./basic_cas.json` file or create a new configuration file.
3. If using a new configuration file, update the `./Dockerfile` entry point:

   ```dockerfile
   COPY <your_config>.json .
   CMD ["nativelink", "<your_config>.json"]
   ```

4. Rebuild the Docker image.

Remember to test your changes thoroughly to ensure they don't negatively impact the build process.
