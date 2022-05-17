#/usr/bin/bash
ips_link='https://raw.githubusercontent.com/khalequzzaman17/anon_ips/main/ipv4.txt'
csf_deny_file='/etc/csf/csf.deny'
csf_deny_bak_file='/etc/csf/csf.deny_bak'
exit_flag=0
csf_reload=0
is_csf_deny_bak_file_exists=0
EPACE='        '

check_input(){
    if [ -z "${1}" ]
    then
        help_message
        exit 1
    fi
}

check_environment(){
    if [ ! -f "$csf_deny_file" ]
    then
        echo "$csf_deny_file does not exists"
        exit_flag=1;
    elif [ ! -f "$csf_deny_bak_file" ]
    then
        echo "Backup $csf_deny_file to $csf_deny_bak_file"
        cp -f $csf_deny_file $csf_deny_bak_file
    fi

    if [ "$EUID" -ne 0 ]
    then
        echo "Please run as root user!"
        exit_flag=1;
    fi

    curl -m 5 -s https://raw.githubusercontent.com/khalequzzaman17/anon_ips/main/ipv4.txt >/dev/null 2>&1
    if [ ${?} != 0 ]
    then 
        echo "${ips_link} not working, please check!"
        exit_flag=1;
    fi

    if [ $exit_flag = "0" ]
    then
        echo "[Success] Environment checked!!"
    else
        echo "[ERROR] Failed Verificaion!!"
        exit 1;
    fi

}

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m"
    echow '-u, --update'
    echo "${EPACE}${EPACE}Backup csf.deny to csf.deny_bak"
    echow '-r, --restore'
    echo "${EPACE}${EPACE}Restore csf.deny from csf.deny_bak"
    echow '-h, --help'
    echo "${EPACE}${EPACE}Display help."
}

resotre_csf_setting(){
    echo 'Restore csf'
    for line in `curl -ks https://raw.githubusercontent.com/khalequzzaman17/anon_ips/main/ipv4.txt`;
    do
        sed -i "/$line/d" $csf_deny_file
    done

    echo 'Restart csf'
    csf -ra >/dev/null 2>&1
}

update_csf_setting(){
    echo 'Update CSF csf.deny'
    for line in `curl -ks https://raw.githubusercontent.com/khalequzzaman17/anon_ips/main/ipv4.txt`;
    do
        if grep -q $line $csf_deny_file
        then
            echo "$line is in $csf_deny_file"
        else
            echo "Append $line to $csf_deny_file"
            echo "$line # Anon IPs" >> $csf_deny_file
            csf_reload=1
        fi
    done

    if [ $csf_reload = 1 ]
    then
        echo 'Restart csf'
        csf -ra >/dev/null 2>&1
    fi

}

check_input ${1}
if [ ! -z "${1}" ]
then
    case ${1} in
        -[hH] | -help | --help)
            help_message
            ;;
        -[uU] | -update | --update)
            check_environment "-u"
            update_csf_setting
            ;;
        -[rR] | -restore | --restore)
            check_environment "-r"
            resotre_csf_setting
            ;;
        *)
            help_message
           ;;
    esac
fi
