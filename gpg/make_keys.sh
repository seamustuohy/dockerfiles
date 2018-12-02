# set -x

#==========================
# For writing to help file.
#==========================
write_help_header()
{
echo "## $1" >> $TMPDIR/README.md
}

write_help()
{
echo "$1" >> $TMPDIR/README.md
}

log()
{
echo "$(date) : $1" >> $TMPDIR/logfile
}


write_config_file() {
    cat << EOF > ~/.gnupg/gpg.conf
use-agent
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
EOF
}


get_configuration_info() {
    log "Getting Configuration Info"
    readonly TMPDIR=$1

    echo "What is the name of the owner?"
    read -e -p "Name:" NAME

    echo "What is their e-mail?"
    read -e -p "e-mail:" EMAIL_ADDR

    echo "Choosing Expiration length"
    PS3='What unit of time to use?'
    # <n>  = key expires in n days
    # <n>w = key expires in n weeks
    # <n>m = key expires in n months
    # <n>y = key expires in n years
    options=("days" "weeks" "months" "years")
    select opt in "${options[@]}"; do
        case $opt in
            "days")
                TIMEUNIT=""
                TIMEUNITDESC="days"
                break
                ;;
            "weeks")
                TIMEUNIT="w"
                TIMEUNITDESC="weeks"
                break
                ;;
            "months")
                TIMEUNIT="m"
                TIMEUNITDESC="months"
                break
                ;;
            "years")
                TIMEUNIT="y"
                TIMEUNITDESC="years"
                break
                ;;
            *) echo "Invalid option. Please choose again.";;
        esac
    done

    echo "How many $TIMEUNITDESC until this key expires?"
    read -e -p "Time until it expires (in $TIMEUNITDESC):" LENGTH_EXP
    readonly EXPIRE_DATE_HUMAN_READ="${LENGTH_EXP} $TIMEUNITDESC"
    readonly EXPIRE_DATE_GPG="${LENGTH_EXP}${TIMEUNIT}"

    #Get Users Password
    while :; do
        echo "Please enter a passphrase for your GPG key (between 0 and 2094597ish chars):"
        echo "WARNING: You cannot use the single quotes char -> ' <- in your passwords."
        read -s -r  -e -p "GPG Key Passphrase:" GPG_PW
        echo ""
        echo -n "Please Re-type your password: "
        read -s -r  -e -p "GPG Key Passphrase:" CONF_GPG_PW
        echo ""
        [ "$GPG_PW" = "$CONF_GPG_PW" ] && break
        echo "Passwords don't match! Try again."
    done
}



#==========================
# GPG Key Manipulation
#==========================
create_keys() {
    log "create_keys"
    # Create Keys
    #
    # Using http://ekaia.org/blog/2009/05/10/creating-new-gpgkey/ as a starting place
    #
    # Key Characteristics
    # - Primary Key: RSA Signing Key 4096 bits long
    # - Sub-Key: RSA Encryption Sub-Key 4096 bits long
    #
    # Why we create a primary signature key and an encryption sub-key
    # - https://security.stackexchange.com/questions/8559/digital-certificate-deployment-using-two-certs-for-each-user/8563#8563
    # - https://security.stackexchange.com/questions/43590/gpg-why-have-separate-encryption-subkey/43591#43591

    gpg --batch --gen-key <<EOF
    %echo Generating Key
    %echo Primary Key = 4096 RSA Signing Key
    Key-Type: RSA
    Key-Length: 4096
    Key-Usage: sign
    %echo Creating Auth Subkey
    %echo Other subkeys created afterwards
    Subkey-Type: RSA
    Subkey-Length: 4096
    Subkey-Usage: auth
    %echo Name = ${NAME}
    Name-Real: ${NAME}
    %echo Email = ${EMAIL_ADDR}
    Name-Email: ${EMAIL_ADDR}
    %echo Expiration = ${EXPIRE_DATE_HUMAN_READ}
    Expire-Date: ${EXPIRE_DATE_GPG}
    Passphrase: ${GPG_PW}
    # Do a commit here, so that we can later print "done" :-)
    %commit
    %echo done
EOF
    # %echo Sub-Key = 4096 RSA Encryption Sub-Key
    # Subkey-Type: RSA
    # Subkey-Length: 4096
    # Subkey-Usage: encrypt
    # %echo Sub-Key = 4096 RSA Signing Sub-Key
    # Subkey-Type: RSA
    # Subkey-Length: 4096
    # Subkey-Usage: sign
    # %echo Sub-Key = 4096 RSA Authentication Sub-Key
    # Subkey-Type: RSA
    # Subkey-Length: 4096
    # Subkey-Usage: auth

    subkeylength=4096
    expire_period=${EXPIRE_DATE_GPG}
    short_id=$(gpg --list-secret-keys --with-colons ${EMAIL_ADDR} | awk -F: '/^sec:/ { print $5 }')
    # Signing Key
    echo addkey$'\n'\
         4$'\n'\
         ${subkeylength}$'\n'\
         "$expire_period"$'\n'\
         save$'\n'\
        | gpg --expert \
              --batch \
            --display-charset utf-8 \
            --passphrase "$GPG_PW" \
            --command-fd 0 \
            --edit-key $short_id
    # Encryption Key
    echo addkey$'\n'\
         6$'\n'\
         ${subkeylength}$'\n'\
         "$expire_period"$'\n'\
         save$'\n'\
        | gpg --expert \
              --batch \
            --display-charset utf-8 \
            --passphrase "$GPG_PW" \
            --command-fd 0 \
            --edit-key $short_id

    # # Authentication Key
    # # Created in original key creation
    # echo addkey$'\n'\
    #      8$'\n'\
    #      S$'\n'\
    #      E$'\n'\
    #      A$'\n'\
    #      q$'\n'\
    #      ${subkeylength}$'\n'\
    #      "$expire_period"$'\n'\
    #      save$'\n'\
    #     | gpg --expert \
    #           --batch \
    #         --display-charset utf-8 \
    #         --passphrase "$GPG_PW" \
    #         --command-fd 0 \
    #         --edit-key $short_id

    write_help_header "Keys Created"
    local KEYS_CREATED_LIST=$(gpg --list-secret-keys)
    write_help "${KEYS_CREATED_LIST}"
}


get_keyids() {
    PRIMARY_KEYID=$(gpg --list-secret-keys --with-colons "${EMAIL_ADDR}" | awk -F: '/^sec:/ { print $5 }')
    ENC_SUB_KEYID=$(gpg --list-secret-keys --with-colons "${EMAIL_ADDR}" | awk -F: '/^ssb:/ { print $12,$5}'|grep -E "^e.*" | cut -d " " -f 2)
    SIGN_SUB_KEYID=$(gpg --list-secret-keys --with-colons "${EMAIL_ADDR}" | awk -F: '/^ssb:/ { print $12,$5}'|grep -E "^s.*" | cut -d " " -f 2)
    AUTH_SUB_KEYID=$(gpg --list-secret-keys --with-colons "${EMAIL_ADDR}" | awk -F: '/^ssb:/ { print $12,$5}'|grep -E "^a.*" | cut -d " " -f 2)
    PUBLIC_KEYID=$(gpg --list-keys --with-colons "${EMAIL_ADDR}" | awk -F: '/^pub:/ { print $5 }')
}

output_keys() {
    log "output_keys"

    #Outputs keys to export directory
    mkdir -p exported_keys
    log "Outputting all secret keys"
    gpg --armor --export-secret-keys "${EMAIL_ADDR}" \
        > exported_keys/${EMAIL_ADDR}-master_and_sub_gpg_keys.asc
    log "Outputting secret sub keys"
    gpg --armor --export-secret-subkeys "${EMAIL_ADDR}" \
        > exported_keys/${EMAIL_ADDR}-sub_gpg_keys.asc
    log "Outputting public keys"
    gpg --armor --export "${EMAIL_ADDR}" \
        > exported_keys/${EMAIL_ADDR}-public_gpg_key.asc
    gpg2 --export-ssh-key "${EMAIL_ADDR}" \
        > exported_keys/${EMAIL_ADDR}-public_gpg_ssh_key.pub
    log "Outputting revocation certificate"
    gpg --gen-revoke "${EMAIL_ADDR}" \
        > exported_keys/revocation-certificate_for_all_keys.asc

    # failsafe_reason="Failsafe Revocation Cert"
    # echo addkey$'\n'\
    #      y$'\n'\
    #      0$'\n'\
    #      ${failsafe_reason}$'\n'\
    #      y$'\n'\
    #     | gpg --expert \
    #           --batch \
    #           --display-charset utf-8 \
    #           --passphrase "$GPG_PW" \
    #           --command-fd 0 \
    #           --gen-revoke "${EMAIL_ADDR}"

}


configure_yubikey() {
    echo "Starting GPG Yubikey process."
    echo "Plug in Yubikey Now"
    sleep 1; echo 5
    sleep 1; echo 4
    sleep 1; echo 3
    sleep 1; echo 2
    sleep 1; echo 1

    prepare_yubikey

    send_keys_to_card
}

send_keys_to_card() {
    echo "Send you keys to your card by following the instructions here:\n\t-\thttps://github.com/drduh/YubiKey-Guide#311-transfer-keys"
}

prepare_yunikey() {
    echo "Preparing Yubikey"
    echo "Type the following commands to change the Yubikeys password...\n1 admin\n2 passwd\n3 3\n4 1\nq\n\quit"
    gpg --card-edit

    echo "Type the following commands to add user information...\nname\nlang\nlogin\nquit\n"
    gpg --card-edit

}


qr_encode_revoke() {
    <"exported_keys/revocation-certificate_for_all_keys.asc" \
     qrencode -o "exported_keys/revoke.qr"
}

qr_encode_secrets() {
    # Export your key (as before):
    gpg --export-secret-keys --armor > private.key
    # Generate files of a maximun size of 2500 byte:
    split -C 2500 private.key splitkey-
    # Convert each to one QR file (same name with extension .qr)
    for file in splitkey-??; do
        <"$file" qrencode -s 3 -d 150 -o "$file".qr
    done
}

qr_decode_secrets() {
    for file in splitkey-??.qr; do
        # `head -c -1` to remove newline added at end
        zbarimg --raw "$file" | head -c -1 >> mergedfile.txt
    done
}

main() {
    log "main"
    get_configuration_info /tmp/

    mkdir -p ~/.gnupg/
    chmod 700 ~/.gnupg/
    cd ~/.gnupg/

    echo "== Creating GPG Keys =="
    create_keys

    echo "== Keys Created =="
    gpg --list-secret-keys
    echo "=================="
    # echo "Import Temporary Keys into GPG build environment"
    # import_temporary_keys

    echo "Outputting GPG Keys & Revocation Certificates"
    echo "Get READY TO COPY PASSWORD NOW"
    sleep 5
    output_keys
    echo "Key Generation Completed!"

    echo "Generating revocation QR code"
    qr_encode_revoke

    log "Completed"

    # log "Start Yubikey"
    # configure_yubikey
}

export GPG_TTY=$(tty)
main
