thwap_id="004"
case "${THWAP_VIMRT}" in
	(true)
		cd ${HOME}/.profile.d
		t_chkdir "${HOME}/.vim/autoload"
		if test ! -e ${HOME}/.vim/autoload/plug.vim; then
			t_status_exec "Installing: plug.vim" "cp files/${thwap_id}-plug.vim ${HOME}/.vim/autoload/plug.vim"
		fi
		if test ! -e ${HOME}/.vimrc; then
			t_status_exec "Installing: vimrc" "cp files/${thwap_id}-vimrc ${HOME}/.vimrc"
		fi
		;;
esac
