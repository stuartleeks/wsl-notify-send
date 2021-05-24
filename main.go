package main

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	toast "gopkg.in/toast.v1"
)

// Overridden via ldflags
var (
	version   = "99.0.1-devbuild"
	commit    = "unknown"
	date      = "unknown"
	goversion = "unknown"
)

func main() {
	var showHelp bool
	var showVersion bool
	var icon string
	var category string
	var appID string

	rootCmd := &cobra.Command{
		Use:   "wsl-notify-send",
		Short: "wsl-notify-send - a WSL integration for notify-send",
		Long:  "wsl-notify-send provides a Windows.exe that accepts parameters similar to the Linux notify-send utility to aid interop. For more customisability, see the toast CLI at https://github.com/go-toast/toast",
		Run: func(cmd *cobra.Command, args []string) {
			if showVersion {
				fmt.Printf("wsl-notify-send version %s\nBuilt %s (commit %s)\n%s\n\n", version, date, commit, goversion)
				return
			}
			if showHelp || len(args) != 1 { // expect single arg with message
				_ = cmd.Usage()
				return
			}
			notification := &toast.Notification{
				AppID:   appID,
				Title:   category,
				Message: args[0],
				Icon:    icon,
			}

			if err := notification.Push(); err != nil {
				log.Fatalln(err)
			}
		},
	}
	// Standard flags
	rootCmd.Flags().BoolVarP(&showHelp, "help", "?", false, "Show a help message")
	rootCmd.Flags().StringVarP(&icon, "icon", "i", "", "An icon filename to display (stock icons are not currently supported)")
	rootCmd.Flags().StringVarP(&category, "category", "c", "wsl-notify-send", "Specifies the notification category")
	// Standard flags that are ignored
	rootCmd.Flags().IntP("expire-time", "t", -1, "[Ignored in wsl-notiy-send]") // TODO - extend go-toast to support https://docs.microsoft.com/en-us/uwp/api/windows.ui.notifications.toastnotification.expirationtime?view=winrt-19041
	rootCmd.Flags().StringArrayP("hint", "h", []string{}, "Ignored in wsl-notify-send")
	rootCmd.Flags().StringArrayP("urgency", "u", []string{}, "Ignored in wsl-notify-send")
	// Custom flags
	rootCmd.Flags().StringVar(&appID, "appId", "wsl-notify-send", "[non-standard] Specifies the app ID")
	rootCmd.Flags().BoolVar(&showVersion, "version", false, "Show version information")
	_ = rootCmd.Execute()
}

// TODO - explore mapping icons: https://wiki.ubuntu.com/NotificationDevelopmentGuidelines#How_do_I_get_these_slick_icons
// 	https://docs.microsoft.com/en-us/uwp/api/windows.ui.notifications.toastnotification?view=winrt-19041
// 	https://docs.microsoft.com/en-us/uwp/schemas/tiles/toastschema/schema-root
