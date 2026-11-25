@echo off
rem Runs report-telemetry on Windows, where the harness cannot.
rem
rem Claude Code and Cursor both run hooks through PowerShell there, and PowerShell has
rem no way to execute a POSIX script: it hands an unknown extension to Windows file
rem association, which opens the script in an editor instead of running it. Cursor finds
rem this file by appending .cmd to the extensionless command in hooks.json, and pipes
rem the hook payload to it on stdin.
rem
rem Git for Windows is looked up by install path before PATH, because PATH usually
rem answers with System32\bash.exe, the WSL launcher, or the Store alias stub. Either one
rem gets a Windows path it cannot resolve, can cold-start WSL inside a 5 second hook
rem timeout, and runs with a Linux HOME, so it would miss an opt-out file written on the
rem Windows side.
setlocal
set "RUNNER=%ProgramFiles%\Git\bin\bash.exe"
if not exist "%RUNNER%" set "RUNNER=%ProgramFiles(x86)%\Git\bin\bash.exe"
if not exist "%RUNNER%" set "RUNNER=bash"

rem Forward slashes, because the script finds its own directory with ${0%/*}. A
rem backslash path has none, so it would fall back to the agent's working directory and
rem read VERSION from there.
set "HOOKS=%~dp0"
set "HOOKS=%HOOKS:\=/%"

rem Exits 0 whatever happens, including with no bash to run at all. A session must never
rem fail, or show an error, because of telemetry. Anything the runner writes to stderr is
rem left alone: the harness keeps it in its hook log, where it is the only way to tell a
rem silent success from a silent failure.
"%RUNNER%" "%HOOKS%report-telemetry" %*
exit /b 0
