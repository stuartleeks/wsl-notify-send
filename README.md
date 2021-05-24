# wsl-notify-send

`wsl-notify-send` provides a Windows executable that is intended to be a replacement for the [Linux `notify-send` utility](https://ss64.com/bash/notify-send.html).




notify-send() { wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}"; }