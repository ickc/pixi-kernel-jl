"""
This installs the Julia Jupyter kernel spec bootstrapped via pixi
to where Jupyter expects it to be.
"""

"""
Get kernel installation target directory for current OS. See
https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernel-specs
"""
function detect_target_dir()
    # %APPDATA%\jupyter\kernels
    if Sys.iswindows()
        appdata = get(ENV, "APPDATA", nothing)
        if appdata !== nothing
            return joinpath(appdata, "jupyter", "kernels")
        else
            # Typical APPDATA path under Windows
            return joinpath(homedir(), "AppData", "Roaming", "jupyter", "kernels")
        end
        # ~/Library/Jupyter/kernels
    elseif Sys.isapple()
        return joinpath(homedir(), "Library", "Jupyter", "kernels")
        # ~/.local/share/jupyter/kernels
    else
        return joinpath(homedir(), ".local", "share", "jupyter", "kernels")
    end
end

"""Install kernel to where Jupyter expects it.

To keep this simple, we do not handle any errors that may arise, e.g., if
the target directory is not writable.
"""
function main(; overwrite::Bool = false)
    target_prefix = detect_target_dir()

    src_dir = joinpath(@__DIR__, "pixi-kernel-jl")
    target_dir = joinpath(target_prefix, "pixi-kernel-jl")

    println(stderr, "Installing kernel spec to $target_dir")
    mkpath(target_prefix)
    cp(src_dir, target_dir; force = overwrite)

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) == 1 && ARGS[1] == "--overwrite"
        main(; overwrite = true)
    else
        main()
    end
end
