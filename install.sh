#!/usr/bin/env bash

echoerr() { printf "%s\n" "$*" >&2; }

# We assume we're logged in to oc

echo "Testing CLI installation."

CLI_INSTALLED=true

if which oc &>/dev/null ; [ $? -ne 0 ];
then
    echoerr "oc not found"
    CLI_INSTALLED=false
fi

if which argocd &>/dev/null ; [ $? -ne 0 ];
then
    echoerr "argocd not found"
    CLI_INSTALLED=false
fi

if which kam &>/dev/null ; [ $? -ne 0 ];
then
    echoerr "kam not found"
    CLI_INSTALLED=false
fi

if which ansible-playbook &>/dev/null ; [ $? -ne 0 ];
then
    echoerr "ansible-playbook not found"
    CLI_INSTALLED=false
fi

if [ $CLI_INSTALLED == false ];
then
    echoerr "One or more CLI programs are missing."
    exit 1
fi

if oc whoami &>/dev/null ; [ $? -ne 0 ];
then
    echoerr "oc is not logged in"
    exit 1
fi

DIR_EXISTS=true

if [ ! -d ../gitops ];
then
    echoerr "Directory '../gitops' could not be found"
    DIR_EXISTS=false
fi

if [ ! -d secrets ];
then
    echoerr "Directory 'secrets' could not be found"
    DIR_EXISTS=false
fi

if [ $DIR_EXISTS == false ];
then
    echoerr "One or more expected directories are missing."
    exit 1
fi

ansible-playbook aro.yaml -f 10 --verbose

echo "Done!"