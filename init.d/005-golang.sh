go_base_url="https://golang.org/dl/"

cp_golang_getarch() {
  case "$(uname -m)" in
    (aarch64) echo "arm64" ;;
    (x86_64)  echo "amd64" ;;
    (i*86)    echo "386"   ;;
  esac
}

cp_golang_bootstrap() {
  strap_vers="1.13.8"
  have_golang=$(which go 2>/dev/null|grep -v 'not found')
  os_name=$(uname -s|tr '[:upper:]' '[:lower:]')
  if test -z "${have_golang}"; then
    if test ! -e "${THWAP_GOLANG_BASE}/strap/bin/go"; then
      cd ${THWAP_GOLANG_BASE}
      fname=go${strap_vers}.${os_name}-$(cp_golang_getarch).tar.gz
      t_fetch https://dl.google.com/go/${fname} /tmp/${fname}
      t_status_exec "Extracting: ${fname}" "tar -zxf /tmp/${fname}"
      t_status_exec "Installing golang bootstrap" "mv go strap"
      echo GOROOT_BOOTSTRAP=${THWAP_GOLANG_BASE}/strap
    else
      echo GOROOT_BOOTSTRAP=${THWAP_GOLANG_BASE}/strap
    fi
  else
    echo
  fi 
}

thwap_golang_latest_version() {
  t_fetch=${THWAP_CMD_FETCH}
  tgv="${t_fetch} ${go_base_url}|grep -e 'downloadBox.*src\.tar\.gz'"
  tgv="${tgv}|awk -F'\"' '{print \$4}'|awk -F'go/go' '{print \$2}'"
  tgv="${tgv}|awk -F'.src' '{print \$1}'"
  echo $(/bin/sh -c "${tgv}")
}

if test "${THWAP_SHELL_INTERACTIVE}" = "true"; then
case "${THWAP_GOLANG}" in
	(true)
		t_chkdir ${THWAP_GOLANG_BASE}
		case "${THWAP_GOLANG_VERSION}" in
			(system)
				thwap_golang_version="ignore"
				;;
			(latest)
        thwap_golang_version=$(thwap_golang_latest_version)
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
          strap=$(cp_golang_bootstrap)
					t_fetch https://dl.google.com/go/go${tgv}.src.tar.gz /tmp/go${tgv}.src.tar.gz
					cd ${THWAP_GOLANG_BASE}
					t_status_exec "Extracting: go${tgv}.src.tar.gz" "tar -zxf /tmp/go${tgv}.src.tar.gz"
					t_status_exec "Preparing : go-${tgv}" "mv go ${tgv} && ln -sf ${tgv} root"
          cd ${THWAP_GOLANG_BASE}/root/src && t_status_exec "Building  : Golang v${tgv}" "env ${strap} ./make.bash" && cd
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
fi

add2path ${GOROOT}/bin
add2path ${GOPATH}/bin
