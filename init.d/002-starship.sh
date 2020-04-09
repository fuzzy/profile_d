thwap_id="002"
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
				case "${THWAP_SHELL_INTERACTIVE}" in
					(true)
						eval $(starship init $(basename ${THWAP_SHELL}))
						;;
				esac
				;;
		esac
		;;
	(*)
		t_error "STARSHIP: You are using an unsupported architecture."
		;;
esac
