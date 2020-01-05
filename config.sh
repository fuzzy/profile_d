##############################################################################
## Utility configuration knobs
##############################################################################

# This will reference our config file. This
# is mainly for the management functions. You
# shouldn't need to change this
THWAP_CONFIG=${HOME}/.profile.d/config.sh

# This is where all downloaded binaries will be dropped
THWAP_BINDIR=${HOME}/.local/bin

# This is where the management functions will
# keep backups of configs and logs.
THWAP_BKUP=${HOME}/.profile.d/.bkups

# This sets the location of the ssh-agent env
# settings file.
THWAP_SSH_ENV=${HOME}/.ssh/ssh.env

# This sets the identity of the main SSH pub key
THWAP_SSH_IDENT=fuzzy@kerplop

# Should we create keys if one is not present
THWAP_SSH_KEY_CREATE="true"

# And if we do, what bitrate should it have?
THWAP_SSH_KEY_SIZE=4096

##############################################################################
## Support layers configuration knobs
##############################################################################

##### GoLang knobs

# If you wish to use the Golang support in the
# thwap utility set. Then set this to true
THWAP_GOLANG="true"

# This sets the location of the golang directories
THWAP_GOLANG_BASE="${HOME}/.local/golang"

# You can set the version of Go to be used, or
# use the special values: latest or system.
# Using 'system' will only setup your $GOPATH
# locally, and use the system $GOROOT.
THWAP_GOLANG_VERSION="latest"

##### Starship prompt
THWAP_STARSHIP="true"
THWAP_STARSHIP_VERSION="0.32.2"

##### Vlang knobs

# Setting this to true will turn on the local vlang
# build and support.
THWAP_VLANG="false"

##### Vim knobs

# If you wish to use the Vim support set this
THWAP_VIMRT="true"

##### Emacs knobs

# Also with emacs
THWAP_EMACSRT="false"
