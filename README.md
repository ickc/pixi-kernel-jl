# pixi-kernel-jl

A small helper and template for using Julia inside a Pixi environment with Jupyter.

This repository has two related goals:

1. Provide a Jupyter kernel that automatically uses the Julia from your Pixi environment.
2. Offer a template to bootstrap and pin a Julia version inside a Pixi configuration so your notebooks use the intended Julia runtime.

## Motivation

Julia projects are reproducible at the package-environment level (for example, `julia --project=@.` will find the environment by searching up the directory tree). However, reproducing the exact Julia *runtime* version used to run that environment is still manual and error-prone. This project helps by providing a kernel and bootstrap pattern that ensures the Julia binary used by Jupyter comes from the pinned Pixi configuration.

## Features

- Installs a Jupyter kernel named `Julia (Pixi)` which launches Julia from the Pixi-managed runtime.
- Includes a Pixi template showing how to pin a Julia release/channel (via `JULIAUP_CHANNEL`) and bootstrap that runtime for reproducible notebooks.

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
- The provided `pixi.toml` demonstrates setting `JULIAUP_CHANNEL` to pin a Julia release/channel. Bootstrap scripts in the template ensure that the pinned Julia is the one actually launched by the kernel.

## Notes and limitations

- The current approach is specific to Julia. The same technique does not directly work for Python kernels (see related projects for Python/R approaches).
- This repository provides a template and a convenience kernel install; adapt or fork it for project-specific needs.

## Troubleshooting

- If the kernel does not appear in Jupyter, run:

        jupyter kernelspec list

    to verify installation and the kernel directory path.

- If the kernel fails to start, ensure:
    - Pixi is correctly installed and `pixi run` works on your machine.

If you need help debugging a failure, collect the output from launching the kernel (or running the launcher script directly) and open an issue or pull request with the details.

## See also

- [renan-r-santos/pixi-kernel](https://github.com/renan-r-santos/pixi-kernel) — Jupyter kernels using Pixi for reproducible notebooks (includes approaches for Python and R).
