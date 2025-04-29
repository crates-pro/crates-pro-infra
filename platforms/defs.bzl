load("@prelude//configurations:util.bzl", "util")

def _extended_execution_platform_impl(ctx: AnalysisContext) -> list[Provider]:
    subinfos = (
        [ctx.attrs.base_platform[PlatformInfo].configuration] +
        [util.constraint_values_to_configuration(ctx.attrs.constraint_values)]
    )

    name = ctx.label.raw_target()
    configuration = util.configuration_info_union(subinfos)

    platform_info = PlatformInfo(
        label = str(name),
        configuration = configuration,
    )

    execution_platform_info = ExecutionPlatformInfo(
        label = name,
        configuration = configuration,
        executor_config = CommandExecutorConfig(
            local_enabled = False,
            remote_enabled = True,
            use_limited_hybrid = True,
            use_windows_path_separators = False,
            # Set those up based on what workers you've registered with NativeLink.
            remote_execution_properties = {
                "OSFamily": "",
                "container-image": "",
            },
            remote_execution_use_case = "buck2-default",
            remote_output_paths = "output_paths",
        ),
    )

    return [
        DefaultInfo(),
        platform_info,
        execution_platform_info,
        ExecutionPlatformRegistrationInfo(platforms = [execution_platform_info]),
    ]

extended_execution_platform = rule(
    impl = _extended_execution_platform_impl,
    attrs = {
        "base_platform": attrs.dep(providers = [PlatformInfo]),
        "constraint_values": attrs.list(attrs.dep(providers = [ConstraintValueInfo])),
    },
)

def _execution_platforms_impl(ctx: AnalysisContext) -> list[Provider]:
    exec_platforms = []
    for platforms in ctx.attrs.platforms:
        exec_platforms = exec_platforms + platforms[ExecutionPlatformRegistrationInfo].platforms

    return [
        DefaultInfo(),
        ExecutionPlatformRegistrationInfo(platforms = exec_platforms),
    ]

execution_platforms = rule(
    impl = _execution_platforms_impl,
    attrs = {
        "platforms": attrs.list(attrs.dep(providers = [ExecutionPlatformRegistrationInfo])),
    },
)
