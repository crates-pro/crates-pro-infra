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

1. Write fixups
2. Implement additional workarounds if 1 is not sufficient
3. Regenerate rules
4. Attempt to build again

#### Fixups

Fixups are defined in `./fixups/<package>/fixups.toml`, where `<package>` is the name of the crate without version information. For more details, see the [Reindeer Manual](https://github.com/facebookincubator/reindeer/blob/main/docs/MANUAL.md).

#### Additional Workarounds

When fixups alone aren't sufficient, we implement additional workarounds in:

- `./run.sh`
- `./fixups/<package>/fixups.toml` containing version information

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

Remember, additional workarounds are version-specific. Always update them to match the package versions in the `BUCK` file.
