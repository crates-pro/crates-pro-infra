load("@prelude//:paths.bzl", "paths")
load("@prelude//rust:rust_toolchain.bzl", "PanicRuntime", "RustToolchainInfo")

def _rust_toolchain_from_sysroot_path_impl(ctx):
    def _bin_false():
        return RunInfo(args = "/bin/false")

    return [
        DefaultInfo(),
        RustToolchainInfo(
            clippy_driver = RunInfo(args = paths.join(ctx.attrs.sysroot_path, "bin", "clippy-driver")),
            compiler = RunInfo(args = paths.join(ctx.attrs.sysroot_path, "bin", "rustc")),
            default_edition = ctx.attrs.default_edition,
            panic_runtime = PanicRuntime("unwind"),
            rustc_binary_flags = ctx.attrs.rustc_binary_flags,
            rustc_flags = ctx.attrs.rustc_flags,
            rustc_target_triple = ctx.attrs.rustc_target_triple,
            rustdoc = RunInfo(args = paths.join(ctx.attrs.sysroot_path, "bin", "rustdoc")),
        ),
    ]

rust_toolchain_from_sysroot_path = rule(
    impl = _rust_toolchain_from_sysroot_path_impl,
    attrs = {
        "sysroot_path": attrs.string(),
        "default_edition": attrs.option(attrs.string(), default = None),
        "rustc_binary_flags": attrs.list(attrs.string(), default = []),
        "rustc_flags": attrs.list(attrs.string(), default = []),
        "rustc_target_triple": attrs.string(default = "x86_64-unknown-linux-gnu"),
    },
    is_toolchain_rule = True,
)
