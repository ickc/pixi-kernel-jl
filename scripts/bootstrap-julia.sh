#!/usr/bin/env bash
JULIAUP_CHANNEL=$(scripts/get_julia_version.py Manifest.toml)
export JULIAUP_CHANNEL
juliaup add "${JULIAUP_CHANNEL}"
