case "${THWAP_SHELL_INTERACTIVE}" in
	(true)
		export TERM_COLS=$(tput cols)
		;;
esac

tc_black="\033[30m"
tb_black="\033[1;30m"
tc_red="\033[31m"
tb_red="\033[1;31m"
tc_green="\033[32m"
tb_green="\033[1;32m"
tc_yellow="\033[33m"
tb_yellow="\033[1;33m"
tc_blue="\033[34m "
tb_blue="\033[1;34m "
tc_purple="\033[35m"
tb_purple="\033[1;35m"
tc_cyan="\033[36m"
tb_cyan="\033[1;36m"
tc_white="\033[37m"
tb_white="\033[1;37m"
tc_end="\033[0m"

t_colmap() {
	for i in 0 1 2 3 4 5 6 7; do
		printf "3${i} = \033[3${i}mTEST\033[0m \033[1;3${i}mTEST\033[0m\n"
	done
}

thwap_reload() {
	source ${HOME}/.profile
}

t_info() {
	printf "[ ${tb_green}OK${tc_end} ] ${*}\n"
}

t_warn() {
	printf "[${tb_yellow}WARN${tc_end}] ${*}\n"
}

t_debug() {
	printf "[${tb_cyan}DEBG${tc_end}] ${*}\n"
}

t_error() {
	printf "[${tb_red}FAIL${tc_end}] ${*}\n"
}

t_status_exec() {
	r_true="[ ${tb_green}OK${tc_end} ]"
	r_false="[${tb_red}FAIL${tc_end}]"
	printf "[    ] ${1}\r"
	/bin/sh -c "${2} 1>/tmp/th_exec.log 2>/tmp/th_exec.err"
	test ${?} -eq 0 && printf "${r_true}\n" || printf "${r_false}\n"
}

t_trunc() {
	case "${THWAP_SHELL_INTERACTIVE}" in
		(true)
			trunc=$((${TERM_COLS} - $((${1}+4))))
			echo "$(echo ${2}|cut -c 1-${trunc})..."
			;;
		(*)
			echo "${2}"
			;;
	esac
}

# This function will test for a directories existence
# and create it if it does not already exist.
t_chkdir() {
	if test ! -d ${1}; then
		t_info "Creating  : ${1}"
		mkdir -p ${1}
	fi
}

# This will fetch files, saving in the named location
# Usage: t_fetch <URL> <OUTPUT>
t_fetch() {
	r_true="[ ${tb_green}OK${tc_end} ]"
	r_false="[${tb_red}FAIL${tc_end}]"
	printf "[    ] Fetching  : $(t_trunc 19 "${1}")\r"
	/bin/sh -c "${THWAP_CMD_FETCH} ${1} >${2}"
	test ${?} -eq 0 && printf "${r_true}\n" || printf "${r_false}\n"
}

# This function just wraps generating random strings
# with openssl for convenience.
trand() {
	echo $(openssl rand -hex ${1})
}

# This function will backup the current on disk config
# to the specified backup directory. Then it will dump
# the current running config variables to the file.
thwap_backup() {
	case "${1}" in
		(config)
			BKUP_FNAME=$(basename ${THWAP_CONFIG}).$(trand 6)
			t_info "Backing up config to: ${BKUP_FNAME}"
			mv ${THWAP_CONFIG} ${THWAP_BKUP}/${BKUP_FNAME}
			t_info "Dumping current config to: ${THWAP_CONFIG}"
			#env|grep THWAP >${THWAP_CONFIG}
			;;
	esac
}

add2path() {
	if test -z "$(echo ${PATH}|grep ${1})"; then
		export PATH=${1}:${PATH}
	fi
}
