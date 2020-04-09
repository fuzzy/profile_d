thwap_find_ssh_ident() {
  for pkey in ${HOME}/.ssh/*.pub; do
    if test ! -z "$(grep ${USER}@$(hostname -s) ${pkey})"; then
      echo ${pkey}
      return
    fi
  done
  echo
  return
}

SSH_AGENT_PID=999999999
test -e ${THWAP_SSH_ENV} && source ${THWAP_SSH_ENV}
SSHPID=$(ps aux|grep ${SSH_AGENT_PID}|grep -v grep|grep ssh|grep ${USER})

if test -z "${SSHPID}"; then
	t_info "Starting  : ssh-agent"
	eval $(ssh-agent -s|grep -v echo|tee ${THWAP_SSH_ENV})
fi

if test ! -z "${THWAP_SSH_IDENT}" && test ! -z "$(thwap_find_ssh_ident ${THWAP_SSH_IDENT})"; then
  SSHID=$(ssh-add -l|grep ${THWAP_SSH_IDENT})
  if test -z "${SSHID}"; then
	  t_info "AddIdent  : ${THWAP_SSH_IDENT} to ssh-agent"
	  ssh-add 2>/dev/null
  fi
elif test -z "${THWAP_SSH_IDENT}" || test -z "$(thwap_find_ssh_ident ${THWAP_SSH_IDENT})"; then
	case "${THWAP_SSH_KEY_CREATE}" in
		(true|"")
			# Well we don't have a default key, and we don't have a running
			# ssh-agent. So let's create a key shall we?
			t_info "Creating  : ${THWAP_SSH_KEY_SIZE} bit ssh key."
			ssh-keygen -t rsa -b ${THWAP_SSH_KEY_SIZE}
			;;
    (*)
			t_info ${THWAP_SSH_KEY_CREATE}
			;;
	esac
fi

