# wsl-notify-send

`wsl-notify-send` provides a Windows executable that is intended to be a replacement for the [Linux `notify-send` utility](https://ss64.com/bash/notify-send.html).

`wsl-notify-send` is implemented using [go-toast/toast](https://github.com/go-toast/toast) and if you have control over the script calling `notify-send`, you will  find that the `toast` CLI gives you more control over the notifications.

## Installation

### Download wsl-notify-send

- Grab the latest release for your platform from https://github.com/stuartleeks/wsl-notify-send/releases
- Extract wsl-notify-send.exe from the downloaded zip and ensure that it is in your `PATH`

### Create the `notify-send` helper

In WSL, create a `notify-send` function that calls `wsl-notify-send`:

```bash
notify-send() { wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}"; }
```

### Testing

In WSL, run `notify-send "Hello from WSL"` and you should see a Windows toast notification!
