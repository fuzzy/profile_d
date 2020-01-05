go_base_url="https://golang.org/dl/"

case "${THWAP_GOLANG}" in
	(true)
		t_chkdir ${THWAP_GOLANG_BASE}
		case "${THWAP_GOLANG_VERSION}" in
			(system)
				thwap_golang_version="ignore"
				;;
			(latest)
				t_fetch=${THWAP_CMD_FETCH}
				tgv="${t_fetch} ${go_base_url}|grep -e 'downloadBox.*src\.tar\.gz'"
				tgv="${tgv}|awk -F'\"' '{print \$4}'|awk -F'go/go' '{print \$2}'"
				tgv="${tgv}|awk -F'.src' '{print \$1}'"
				thwap_golang_version=$(/bin/sh -c "${tgv}")
				;;
			(*)
				thwap_golang_version=${THWAP_GOLANG_VERSION}
				;;
		esac
		case "${thwap_golang_version}" in
			(ignore)
				# Let's be proper here and do *something* since
				# if I recall correctly some shell's do not like
				# this to be empty
				echo >/dev/null
				;;
			(*)
				tgv=${thwap_golang_version}
				if test ! -x ${THWAP_GOLANG_BASE}/${tgv}/bin/go; then
					t_fetch https://dl.google.com/go/go${tgv}.src.tar.gz /tmp/go${tgv}.src.tar.gz
					cd ${THWAP_GOLANG_BASE}
					t_status_exec "Extracting: go${tgv}.src.tar.gz" "tar -zxf /tmp/go${tgv}.src.tar.gz"
					t_status_exec "Installing: go-${tgv}" "mv go ${tgv} && ln -sf ${tgv} root"
					cd ${THWAP_GOLANG_BASE}/root/src && t_status_exec "Building  : Golang v${tgv}" "./make.bash" && cd
					rm -f /tmp/go${tgv}.src.tar.gz
				fi
				export GOROOT=${THWAP_GOLANG_BASE}/root
				;;
		esac
		t_chkdir ${THWAP_GOLANG_BASE}/path
		cd ${THWAP_GOLANG_BASE} && ln -sf ${tgv} root && cd
		export GOPATH=${THWAP_GOLANG_BASE}/path
		;;
esac
