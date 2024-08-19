# Third-party Dependencies

This folder manages third-party dependencies for the project. The `Cargo.toml` file here is a merged manifest that includes all Rust crate dependencies used across the project.

We use [Reindeer](https://github.com/facebookincubator/reindeer) to import these crate dependencies and generate Buck build rules (`./BUCK`).

## Usage

To regenerate the `BUCK` file from `Cargo.toml`, run:

```bash
./run.sh
```

## Resolving Build Issues

When Reindeer-generated rules fail to build, we apply the following process:

1. Write fixups and patches
2. Regenerate rules
3. Attempt to build again

#### Fixups

We use two types of fixups to resolve build issues:

1. Fixup files: Located in `./fixups/<package>/fixups.toml`, where `<package>` is the crate name without version information.
2. Script-based fixups: Implemented directly in the `./run.sh` script.

**Fixup files** are TOML files that provide additional configuration for Reindeer when generating build rules. They work in conjunction with `Cargo.toml` to refine the build rule. For more details on how to write a fixup, refer to the [Reindeer Manual](https://github.com/facebookincubator/reindeer/blob/main/docs/MANUAL.md).

**Script-based fixups** are located in `./run.sh`. This script executes Reindeer to generate an initial `BUCK` file, then add additional modifications to the `BUCK` file.

Fixups may be version-specific, always update them to match the package versions in the `BUCK` file. Refer to the "Maintenance" section below for deatils.

#### Patches

Patches are stored in the `vendor` directory. Currently, there's a patch for the `utoipa-swagger-ui` crate.

## Maintenance

After generating the `BUCK` file, verify that all additional workarounds are still valid. Follow these two steps:

#### Step 1: Verify `./run.sh`

Check that these package versions in `./BUCK` match:

```
mime_guess==2.0.x
libtugraph-sys==0.1.2+3.5.0
```

If versions differ, update `./run.sh`.

#### Step 2: Verify `./fixups/**/fixups.toml`

Check that these package versions in `./BUCK` match:

```
rdkafka-sys==4.7.0+2.3.0
libgit2-sys==0.17.0+1.8.1
openssl-sys==0.9.103
ring=0.17.8
```

If versions differ, update the corresponding `./fixups/**/fixups.toml`.

#### Step 3: Update patches

We currently maintain a patch for the `utoipa-swagger-ui` crate in the `vendor` directory.:

Patch location: `vendor/utoipa-swagger-ui-7.1.0-patch1`

How the patch works:

1. The original `build.rs` script downloads resources at build time, which can be problematic.
2. To avoid this, we pre-download the resources in the remote builder Docker image.
3. We then modify `src/lib.rs` to use these pre-downloaded resources instead of relying on `build.rs`.

When updating `utoipa-swagger-ui`:

1. Update the patch accordingly.
2. Ensure that the remote builder image downloads the correct version of resources.
3. Verify that `src/lib.rs` correctly references the pre-downloaded resources.
