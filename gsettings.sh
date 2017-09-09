#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
#
# expected command line arguments
#
# Created by "Himanshu Shekhar"
# For ProxyMan "https://github.com/himanshub16/ProxyMan/"
#
# convention to be followed across extension made / to be made
# include this comment section in all plugins to avoid confusions while coding
#
# plugin to set "GNOME Desktop" proxy settings for ProxyMan
#
# The arguments are given in bash syntax to maintain universality and ease
# across all UNIX systems.
# Your language can use it's respective syntax for
# arguments and comments.
# If you don't need any particular proxy settings, ignore the variables.

# $#  : number of arguments
# $1  : http_host
# if this is "toggle", toggle settings.
# if this argument is "unset", proxy settings should be unset.

# $2  : http_port
# $3  : use_same ; "y" or "n"
# $4  : use_auth
# $5  : username ; send empty string if not available
# $6  : password ; send empty string if not available
#
# if use same is yes, then no further arguments are considered
#
# $7  : https_host
# $8  : https_port
# $9  : ftp_host
# $10 : ftp_port

# here your code starts

# privileges has to be set by the process which starts this script

# gettings : this is what Ubuntu and other GNOME based distributions use
# for storing configuration
# Your system settings UI uses ${GSETTINGS} at the backend.

GSETTINGS=/usr/bin/gsettings

list_proxy() {
	echo
	echo -e "\e[1m Desktop proxy settings (GNOME)\e[0m"
	mode="$(${GSETTINGS} get org.gnome.system.proxy mode)"
	if [ "$mode" = "'none'" ]; then
		echo -e "\e[36m None \e[0m"
		return
	fi

	echo -e "\e[36m HTTP  Proxy \e[0m" Host : $(${GSETTINGS} get org.gnome.system.proxy.http host) Port : $(${GSETTINGS} get org.gnome.system.proxy.http port)
	echo -e "\e[36m Auth        \e[0m" User  : $(${GSETTINGS} get org.gnome.system.proxy.http authentication-user) Password : $(${GSETTINGS} get org.gnome.system.proxy.http authentication-password)
	echo -e "\e[36m HTTPS Proxy \e[0m" Host : $(${GSETTINGS} get org.gnome.system.proxy.https host) Port : $(${GSETTINGS} get org.gnome.system.proxy.https port)
	echo -e "\e[36m FTP   Proxy \e[0m" Host : $(${GSETTINGS} get org.gnome.system.proxy.ftp host) Port : $(${GSETTINGS} get org.gnome.system.proxy.ftp port)
	echo -e "\e[36m SOCKS Proxy \e[0m" Host : $(${GSETTINGS} get org.gnome.system.proxy.socks host) Port : $(${GSETTINGS} get org.gnome.system.proxy.socks port)

}

toggle_proxy() {
	if [ "$(${GSETTINGS} get org.gnome.system.proxy mode)" = "none" ]; then
		${GSETTINGS} set org.gnome.system.proxy mode "manual"
	else
		${GSETTINGS} set org.gnome.system.proxy mode "none"
	fi
}

unset_proxy() {
	${GSETTINGS} set org.gnome.system.proxy mode "none"
	${GSETTINGS} set org.gnome.system.proxy.http host \"\"
	${GSETTINGS} set org.gnome.system.proxy.http port 0
	${GSETTINGS} set org.gnome.system.proxy.https host "\"\""
	${GSETTINGS} set org.gnome.system.proxy.https port 0
	${GSETTINGS} set org.gnome.system.proxy.ftp host "\"\""
	${GSETTINGS} set org.gnome.system.proxy.ftp port 0
	${GSETTINGS} set org.gnome.system.proxy.socks host "\"\""
	${GSETTINGS} set org.gnome.system.proxy.socks port 0
	${GSETTINGS} set org.gnome.system.proxy.http use-authentication false
	${GSETTINGS} set org.gnome.system.proxy.http authentication-user "\"\""
	${GSETTINGS} set org.gnome.system.proxy.http authentication-password "\"\""
}

set_proxy() {
	if [ "$4" = "y" ]; then
		${GSETTINGS} set org.gnome.system.proxy.http authentication-user "$5"
		${GSETTINGS} set org.gnome.system.proxy.http authentication-password "$6"
	fi
	if [ "$3" = "y" ]; then
		${GSETTINGS} set org.gnome.system.proxy.http host $1
		${GSETTINGS} set org.gnome.system.proxy.http port $2
		${GSETTINGS} set org.gnome.system.proxy.https host $1
		${GSETTINGS} set org.gnome.system.proxy.https port $2
		${GSETTINGS} set org.gnome.system.proxy.ftp host $1
		${GSETTINGS} set org.gnome.system.proxy.ftp port $2
		${GSETTINGS} set org.gnome.system.proxy.socks host $1
		${GSETTINGS} set org.gnome.system.proxy.socks port $2
	elif [ "$3" = "n" ]; then
		${GSETTINGS} set org.gnome.system.proxy.http host $1
		${GSETTINGS} set org.gnome.system.proxy.http port $2
		${GSETTINGS} set org.gnome.system.proxy.https host $7
		${GSETTINGS} set org.gnome.system.proxy.https port $8
		${GSETTINGS} set org.gnome.system.proxy.ftp host $9
		${GSETTINGS} set org.gnome.system.proxy.ftp port $10
		${GSETTINGS} set org.gnome.system.proxy.socks host $9
		${GSETTINGS} set org.gnome.system.proxy.socks port $10
	fi
	${GSETTINGS} set org.gnome.system.proxy mode "manual"
}


gsettings_available="$(which ${GSETTINGS})"
if [ "$gsettings_available" = "" ]; then
	exit
fi

if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	# that's what is needed
	unset_proxy
	exit
# elif [ "$1" = "toggle" ]; then
# 	toggle_proxy
	exit
elif [ "$1" = "list" ]; then
	list_proxy
	exit
fi


unset_proxy
set_proxy $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
