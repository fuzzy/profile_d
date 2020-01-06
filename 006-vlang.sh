thwap_id="006"
case "${THWAP_VLANG}" in
	(true)
		if test ! -d ${THWAP_VLANG_BASE}; then
			t_status_exec "Cloning   : Vlang (github.com/vlang/v)" "git clone https://github.com/vlang/v ${THWAP_VLANG_BASE}"
			cd ${THWAP_VLANG_BASE}
			t_status_exec "Building  : Vlang (Git master)" "make"
			cd
		fi

		if test ! -L ${THWAP_BINDIR}/v; then
			t_status_exec "Linking   : Vlang (Git master)" "ln -sf ${THWAP_VLANG_BASE}/v ${THWAP_BINDIR}/v"
		fi
		;;
esac
