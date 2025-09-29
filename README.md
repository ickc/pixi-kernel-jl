# pixi-kernel-jl

A small helper and template for using Julia inside a Pixi environment with Jupyter.

This repository has two related goals:

1. Provide a Jupyter kernel that automatically uses the Julia from your Pixi environment.
2. Offer a template to bootstrap and pin a Julia version inside a Pixi configuration so your notebooks use the intended Julia runtime.

## Motivation

Julia projects are reproducible at the package-environment level (for example, `julia --project=@.` will find the environment by searching up the directory tree). However, reproducing the exact Julia *runtime* version used to run that environment is still manual and error-prone. This project helps by providing a kernel and bootstrap pattern that ensures the Julia binary used by Jupyter comes from the pinned Pixi configuration.

## Features

- Installs a Jupyter kernel named `Julia (Pixi)` which launches Julia from the Pixi-managed runtime.
- Includes a Pixi template showing how to pin a Julia release/channel and bootstrap that runtime for reproducible notebooks.
- Reads the pinned Julia runtime version from `Manifest.toml` (the `julia_version` key) and uses that to set `JULIAUP_CHANNEL` when bootstrapping.

## Requirements

- Pixi installed and available in your environment.
- Jupyter (or JupyterLab) installed and available.

## Quick install

1. Clone this repository:

        git clone git@github.com:ickc/pixi-kernel-jl.git

2. Change into the repository:

        cd pixi-kernel-jl

3. Run the install script through Pixi:

        pixi run install-kernel

Be patient — on a cold start the installation may take around 90 seconds.

By default, the install will create or overwrite a kernel named `pixi-kernel-jl` inside your Jupyter kernels directory. You can confirm the installed kernels with:

        jupyter kernelspec list

## How it works (high level)

- The kernel spec installed by `pixi run install-kernel` points Jupyter to a launcher script that activates the Pixi environment and then runs the pinned Julia binary from that environment.
- The bootstrap/activation scripts consult `Manifest.toml` and read the `julia_version` key to determine which Julia runtime to install/activate. A small helper script at `scripts/get_julia_version.py` is used to extract `julia_version` from `Manifest.toml` and that value is used to set `JULIAUP_CHANNEL` for the bootstrap process.
- The provided `pixi.toml` demonstrates this pattern: the activation scripts call the bootstrap script which in turn uses the `julia_version` value to ensure the correct Julia runtime is available in the Pixi-managed environment.

## Bootstrapping notes (important)

- The current flow expects a `Manifest.toml` file to exist in the project root that contains a `julia_version` entry. The bootstrap scripts read that value and use it to set `JULIAUP_CHANNEL` so the correct Julia runtime is installed in the Pixi environment.
- If you are setting up a new Julia project and do not yet have a `Manifest.toml`, the bootstrap will fail because there is nothing to read. To allow bootstrapping in that case, create a minimal `Manifest.toml` at the project root with a single line specifying the desired Julia runtime, for example:

    `julia_version = "1.11.7"  # <- desired version`

  After creating this file you can run the Pixi bootstrap/install steps (for example, `pixi run precompile`) and the system will use that `julia_version` to install and pin the Julia runtime. Once the full Julia environment is created (the normal package manager operations run), the real `Manifest.toml` produced by Julia/Pkg will replace this placeholder file — so the single-line file is just a temporary helper to get the bootstrap started.

- The helper script `scripts/get_julia_version.py` reads `Manifest.toml` and prints the `julia_version` value. You can inspect or run it directly:

    `python scripts/get_julia_version.py Manifest.toml`

  This will print the version string that the bootstrap code uses to set `JULIAUP_CHANNEL`.

## Example behavior

- With a proper `Manifest.toml` containing `julia_version = ...`, the activation/bootstrap will set `JULIAUP_CHANNEL` to that version and install/activate the corresponding Julia runtime inside the Pixi environment (using the `JULIA_DEPOT_PATH` / `JULIAUP_DEPOT_PATH` redirected into the Pixi prefix).
- If you initially created the single-line `Manifest.toml` as a bootstrap helper, it will be overwritten by the complete `Manifest.toml` produced when Julia's package manager instantiates the environment.

## pixi.toml

The example `pixi.toml` included in this repository demonstrates the necessary activation hooks. The activation scripts in `pixi.toml` call the bootstrap script which uses `scripts/get_julia_version.py` to find the desired Julia version from `Manifest.toml`. See `pixi.toml` for platform-specific activation entries and environment variable wiring.

## Notes and limitations

- The current approach is specific to Julia. The same technique does not directly work for Python kernels (see related projects for Python/R approaches).
- This repository provides a template and a convenience kernel install; adapt or fork it for project-specific needs.

## Troubleshooting

- If the kernel does not appear in Jupyter, run:

        jupyter kernelspec list

    to verify installation and the kernel directory path.

- If the kernel fails to start, ensure:
    - Pixi is correctly installed and `pixi run` works on your machine.
    - `Manifest.toml` exists in the project root and contains a `julia_version` entry (or the temporary single-line file described above, if you are bootstrapping a new project).

If you need help debugging a failure, collect the output from launching the kernel (or running the launcher script directly) and open an issue or pull request with the details.

## See also

- [renan-r-santos/pixi-kernel](https://github.com/renan-r-santos/pixi-kernel) — Jupyter kernels using Pixi for reproducible notebooks (includes approaches for Python and R).
