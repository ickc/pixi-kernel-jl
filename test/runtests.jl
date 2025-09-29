using Test

env_key_equals(key, value) = get(ENV, key, nothing) == value

@testset "Pixi environment variables" begin
    @test env_key_equals("JULIA_PROJECT", "@.")
    @test env_key_equals("JULIAUP_CHANNEL", "1.11.6")

    expected = joinpath(ENV["CONDA_PREFIX"], ".julia")

    @test env_key_equals("JULIA_DEPOT_PATH", expected)
    @test env_key_equals("JULIAUP_DEPOT_PATH", expected)
end
