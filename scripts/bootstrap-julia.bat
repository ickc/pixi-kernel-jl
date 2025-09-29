@echo off

REM Run the Python script and capture its output into the JULIAUP_CHANNEL variable.
FOR /F "usebackq delims=" %%i IN (`python scripts/get_julia_version.py Manifest.toml`) DO SET "JULIAUP_CHANNEL=%%i"

REM Use the variable to add the correct Julia version via juliaup.
juliaup add "%JULIAUP_CHANNEL%"
