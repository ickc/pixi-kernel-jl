#!/usr/bin/env python3
"""Get the Julia version from the Manifest.toml file."""
import argparse
import tomllib
from pathlib import Path


def main(path: Path) -> str:
    with path.open("rb") as f:
        return tomllib.load(f)["julia_version"]


def cli():
    arg = argparse.ArgumentParser(description=__doc__)
    arg.add_argument("path", type=Path, help="Path to Manifest.toml")
    args = arg.parse_args()
    print(main(args.path))


if __name__ == "__main__":
    cli()
