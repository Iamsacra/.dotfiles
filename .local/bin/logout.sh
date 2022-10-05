RET=$(echo "cancel\nlogout\nreboot\nshutdown" | dmenu -fn 'Ubuntu-16' -sb '#535d6c' -p "Logout")

case $RET in
	shutdown) poweroff ;;
	reboot) reboot ;;
	logout) xdotool key "super+shift+q" ;;
	*) ;;
esac
