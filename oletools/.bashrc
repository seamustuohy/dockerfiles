alias oledump="python2 /code/oledump/oledump.py --plugindir=/code/oledump/"

alias what_plugins="find /code/oledump/. -name \"plugin_*\" -exec basename {} \; | cut -d . -f 1"
alias what_decoder="find /code/oledump/. -name \"decoder_*\" -exec basename {} \; | cut -d . -f 1"
alias what_yara="find /code/oledump/. -name \"*.yara\" -exec basename {} \; "
