thwap_id="003"
case "$(uname -m)" in
	(x86_64|amd64)
		case "${THWAP_STARSHIP}" in
			(true)
				TSU_BASE="https://github.com/starship/starship/releases/download/v${THWAP_STARSHIP_VERSION}"
				TSU="${TSU_BASE}/starship-x86_64-unknown-linux-gnu.tar.gz"
				if test ! -x ${THWAP_BINDIR}/starship; then
					t_fetch "${TSU}" "/tmp/starship.tgz"
					t_status_exec "Extracting: starship" "tar -zxf /tmp/starship.tgz -C ${THWAP_BINDIR}/"
					rm -f /tmp/starship.tgz
					chmod +x ${THWAP_BINDIR}/starship
				fi
				if test ! -e ${HOME}/.config/starship.toml; then
					t_chkdir ${HOME}/.config
					t_status_exec "Installing: starship.toml" "cp ${HOME}/.profile.d/files/${thwap_id}-starship.toml ${HOME}/.config/starship.toml"
				fi
				eval $(starship init $(basename ${THWAP_SHELL}))
				;;
		esac
		;;
	(*)
		t_error "You are using an unsupported architecture."
		;;
esac
