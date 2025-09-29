using Test

# Use Julia stdlib to normalize paths (abspath + normpath)
norm(p::AbstractString) = normpath(abspath(p))

# Check whether an environment-variable-style path list contains the expected path.
# PATH separator is ';' on Windows and ':' on Unix-like systems.
function path_list_contains(envval::AbstractString, expected::AbstractString)
    sep = Sys.iswindows() ? ';' : ':'
    for part in split(envval, sep)
        if norm(part) == norm(expected)
            return true
        end
    end
    return false
end

@testset "Pixi kernel environment variables" begin
    @test haskey(ENV, "JULIA_PROJECT") && ENV["JULIA_PROJECT"] == "@."
    @test haskey(ENV, "JULIAUP_CHANNEL") && ENV["JULIAUP_CHANNEL"] == "1.11.6"

    expected = joinpath(ENV["CONDA_PREFIX"], ".julia")

    @test haskey(ENV, "JULIA_DEPOT_PATH")
    @test haskey(ENV, "JULIAUP_DEPOT_PATH")

    @test path_list_contains(ENV["JULIA_DEPOT_PATH"], expected)
    @test path_list_contains(ENV["JULIAUP_DEPOT_PATH"], expected)
end
