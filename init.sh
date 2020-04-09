set -a
SSH_ASKPASS=/usr/bin/ssh-askpass

# Shell detection
if test ! -z "${ZSH_NAME}"; then
	THWAP_SHELL=zsh
elif test ! -z "${BASH}"; then
	THWAP_SHELL=bash
fi

case "${THWAP_SHELL}" in
	(zsh)
		if [[ -o login ]]; then
			THWAP_SHELL_INTERACTIVE="true"
		else
			THWAP_SHELL_INTERACTIVE="false"
		fi
		;;
	(bash)
		if [[ $- == *i* ]]; then
			THWAP_SHELL_INTERACTIVE="true"
		else
			THWAP_SHELL_INTERACTIVE="false"
		fi
		;;
esac

# Some base utility detection
if test -z "${THWAP_CMD_FETCH}"; then
	if test ! -z "$(which wget 2>/dev/null)"; then
		THWAP_CMD_FETCH="wget -qO-"
	elif test ! -z "$(which curl 2>/dev/null)"; then
		THWAP_CMD_FETCH="curl -q"
	elif test ! -z "$(which fetch 2>/dev/null)"; then
		THWAP_CMD_FETCH="fetch -q"
	elif test ! -z "$(which ftp 2>/dev/null)"; then
		THWAP_CMD_FETCH="ftp -q"
	fi
fi

test -e ${HOME}/.profile.d/config.sh && source ${HOME}/.profile.d/config.sh
set +a

test -e ${HOME}/.profile.d/libthwap.sh && source ${HOME}/.profile.d/libthwap.sh
t_chkdir ${THWAP_BINDIR}
add2path ${THWAP_BINDIR}

for fn in ${HOME}/.profile.d/init.d/???-*.sh; do
	source ${fn}
done

