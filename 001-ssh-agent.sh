# If we don't have a default ssh identity set, then we
# will detect one from ~/.ssh/id_rsa.pub
if test -z "${THWAP_SSH_IDENT}"; then
	if test -e ${HOME}/.ssh/id_rsa.pub; then
		THWAP_SSH_IDENT=$(awk '{print $3}' ${HOME}/.ssh/id_rsa.pub)
		t_info "Using ${THWAP_SSH_IDENT} from ~/.ssh/id_rsa.pub as default."
	else
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
fi

SSH_AGENT_PID=999999999
test -e ${THWAP_SSH_ENV} && source ${THWAP_SSH_ENV}
SSHPID=$(ps aux|grep ${SSH_AGENT_PID}|grep -v grep|grep ssh|grep ${USER})

if test -z "${SSHPID}"; then
	t_info "Starting  : ssh-agent"
	eval $(ssh-agent -s|grep -v echo|tee ${THWAP_SSH_ENV})
fi

SSHID=$(ssh-add -l|grep ${THWAP_SSH_IDENT})
if test -z "${SSHID}"; then
	t_info "AddIdent  : ${THWAP_SSH_IDENT} to ssh-agent"
	ssh-add
fi

