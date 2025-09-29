using Test
using TOML

env_key_equals(key, value) = get(ENV, key, nothing) == value

@testset "Pixi environment variables" begin
    @test env_key_equals("JULIA_PROJECT", "@.")

    manifest = TOML.parsefile("Manifest.toml")
    julia_version = manifest["julia_version"]
    @test env_key_equals("JULIAUP_CHANNEL", julia_version)

    expected = joinpath(ENV["CONDA_PREFIX"], ".julia")

    @test env_key_equals("JULIA_DEPOT_PATH", expected)
    @test env_key_equals("JULIAUP_DEPOT_PATH", expected)
end
