## Script to copy LetsEncrypt certificates to InspIRCd
## Run this after certbot renew !
## Dorian Harmans <contact@dorianharmans.nl>
## ---------------------------------------------------

#!/bin/bash

LETSENCRYPTDIR="/root/.acme.sh"

IRCSERVERNAME="learninweb.homelinuxserver.org"
IRCSERVERUSER=inspircd
IRCSERVERCONFDIR="/etc/inspircd/certs"

SRC_CERTDIR="${LETSENCRYPTDIR}/${IRCSERVERNAME}"
SRC_FULLCHAIN="${SRC_CERTDIR}/fullchain.cer"
SRC_KEY="${SRC_CERTDIR}/learninweb.homelinuxserver.org.key"

TGT_CRT="${IRCSERVERCONFDIR}/fullchain.cer"
TGT_KEY="${IRCSERVERCONFDIR}/learninweb.homelinuxserver.org.key"

if [ -e $SRC_FULLCHAIN ]; then
        cp $SRC_FULLCHAIN $TGT_CRT
        chown $IRCSERVERUSER:$IRCSERVERUSER $TGT_CRT
        chmod 0640 $TGT_CRT
else
        echo -e "Failed!\nReason: ${SRC_FULLCHAIN} not found"
        exit 1
fi

if [ -e $SRC_KEY ]; then
        cp $SRC_KEY $TGT_KEY
        chown $IRCSERVERUSER:$IRCSERVERUSER $TGT_KEY
        chmod 0600 $TGT_KEY
else
        echo -e "Failed!\nReason: ${SRC_KEY} not found"
        exit 1
fi

if [ -e $TGT_CRT ] && [ -e $TGT_KEY ]; then
        /bin/systemctl reload inspircd.service
else
        echo -e "Failed!\nReason: ${TGT_CRT} and/or ${TGT_KEY} not found"
        exit 1
fi

exit 0
