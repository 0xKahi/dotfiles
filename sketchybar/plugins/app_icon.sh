#!/bin/bash

source "$CONFIG_DIR/icons.sh"

case "$1" in
"Ghostty")
	RESULT=$ICON_GHOSTTY
	;;
"Terminal" | "Warp" | "iTerm2")
  RESULT=$ICON_TERM
	;;
"Finder")
	RESULT=$ICON_FINDER
	;;
"Weather")
	RESULT=$ICON_WEATHER
	;;
"Clock")
	RESULT=$ICON_CLOCK
	;;
"Mail" | "Microsoft Outlook")
	RESULT=$ICON_MAIL
	;;
"Calendar")
	RESULT=$ICON_CALENDAR
	;;
"Calculator" | "Numi")
	RESULT=$ICON_CALC
	;;
"Maps" | "Find My")
	RESULT=$ICON_MAP
	;;
"Voice Memos")
	RESULT=$ICON_MICROPHONE
	;;
"Messages" | "Slack" | "Microsoft Teams")
	RESULT=$ICON_CHAT
	;;
"Telegram")
	RESULT=$ICON_TELEGRAM
	;;
"Discord")
	RESULT=$ICON_DISCORD
	;;
"WhatsApp")
	RESULT=$ICON_WHATSAPP
	;;
"FaceTime" | "zoom.us" | "Webex")
	RESULT=$ICON_VIDEOCHAT
	;;
"Notes" | "TextEdit" | "Stickies" | "Microsoft Word")
	RESULT=$ICON_NOTE
	;;
"Reminders" | "Microsoft OneNote")
	RESULT=$ICON_LIST
	;;
"Things")
	RESULT=$ICON_THINGS
	;;
"Photo Booth")
	RESULT=$ICON_CAMERA
	;;
"Beam" | "DuckDuckGo" | "Arc" | "Microsoft Edge")
	RESULT=$ICON_WEB
	;;
"Brave Browser")
	RESULT=$ICON_BRAVE
	;;
"Safari")
	RESULT=$ICON_SAFARI
	;;
"Comet")
	RESULT=$ICON_COMET
	;;
"Google Chrome")
	RESULT=$ICON_CHROME
	;;
"Firefox")
	RESULT=$ICON_FIREFOX
	;;
"System Settings" | "System Information" | "TinkerTool")
	RESULT=$ICON_COG
	;;
"HOME")
	RESULT=$ICON_HOMEAUTOMATION
	;;
"Music" | "Spotify")
	RESULT=$ICON_MUSIC
	;;
"Podcasts")
	RESULT=$ICON_PODCAST
	;;
"TV" | "QuickTime Player" | "VLC")
	RESULT=$ICON_PLAY
	;;
"Books")
	RESULT=$ICON_BOOK
	;;
"Code")
	RESULT=$ICON_VSCODE
	;;
"Xcode" | "Neovide")
	RESULT=$ICON_DEV
	;;
"VSCodium")
	RESULT=$ICON_VSCODIUM
	;;
"Dictionary")
	RESULT=$ICON_BOOKINFO
	;;
"Font Book")
	RESULT=$ICON_FONTBOOK
	;;
"Activity Monitor")
	RESULT=$ICON_CHART
	;;
"Disk Utility")
	RESULT=$ICON_DISK
	;;
"Screenshot" | "Preview")
	RESULT=$ICON_PREVIEW
	;;
"Passwords")
	RESULT=$ICON_PASSWORDS
	;;
"iPhone Mirroring")
	RESULT=$ICON_MIRROR
	;;
"NordVPN")
	RESULT=$ICON_VPN
	;;
"Progressive Downloaded" | "Transmission")
	RESULT=$ICON_DOWNLOAD
	;;
"Airflow")
	RESULT=$ICON_CAST
	;;
"Microsoft Excel" | "Numbers")
	RESULT=$ICON_TABLE
	;;
"Microsoft PowerPoint" | "Keynote" | "Google Slides")
	RESULT=$ICON_PRESENT
	;;
"OneDrive")
	RESULT=$ICON_CLOUD
	;;
"Curve")
	RESULT=$ICON_PEN
	;;
"VMware Fusion" | "UTM")
	RESULT=$ICON_REMOTEDESKTOP
	;;
"Adobe Photoshop 2024")
	RESULT=$ICON_PHOTOSHOP
	;;
"Adobe After Effects")
	RESULT=$ICON_AFTEREFFECTS
	;;
"Photos" | "Lightroom Classic")
	RESULT=$ICON_PHOTOS
	;;
"Figma")
	RESULT=$ICON_FIGMA
	;;
"KiCad")
	RESULT=$ICON_KICAD
	;;
"JDownloader2")
	RESULT=$ICON_DOWNLOAD
	;;
"SF Symbols")
	RESULT=$ICON_ICON
	;;
"Steam" | "Steam Helper")
	RESULT=$ICON_STEAM
	;;
"HandBrake")
	RESULT=$ICON_HANDBRAKE
	;;
"GLMv4" | "GLMv5")
	RESULT=$ICON_GLM
	;;
"Popcorn-Time")
	RESULT=$ICON_POPCORN
	;;
"InDesign")
	RESULT=$ICON_INDESIGN
	;;
"Adobe Illustrator 2024")
	RESULT=$ICON_ILLUSTRATOR
	;;
"DaisyDisk")
	RESULT=$ICON_DAISYDISK
	;;
"Docker Desktop" | "Docker")
	RESULT=$ICON_DOCKER
	;;
"DataGrip")
	RESULT=$ICON_DATAGRIP
	;;
"Surfshark")
	RESULT=$ICON_SURFSHARK
	;;
"Obsidian")
	RESULT=$ICON_NOTES
	;;
*)
	RESULT=$ICON_APP
	;;
esac

echo $RESULT
