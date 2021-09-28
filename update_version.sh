#!/bin/bash
verify_with() {
    local fingerprint=$1
    local file=$2
    local status

    status=$(gpg --status-fd=4 --trust-model=always --verify "$file" 4>&1 >/dev/null 2>&1)

    if grep -qs "^\[GNUPG:\] VALIDSIG ${fingerprint}" <<< "$status"; then
        echo "********** GPG Signature OK **********"
        return 0
    else
        echo "********** GPG Signature Invalid **********"
        return 1
    fi
}


if [ $# != 1 ]; then
  echo "Usage: ./update_version.sh <electrum_mona_version>"
  exit 1
fi

ELECTRUM_VERSION="$1"
ELECTRUM_GPG_FINGERPRINT="315525E811D5E586F3CAC0329C740BEC897CE499"

echo "---> Verify tarball signature"
wget https://github.com/wakiyamap/electrum-mona/releases/download/${ELECTRUM_VERSION}/Electrum-MONA-${ELECTRUM_VERSION}.tar.gz -O Electrum-MONA-${ELECTRUM_VERSION}.tar.gz
wget https://github.com/wakiyamap/electrum-mona/releases/download/${ELECTRUM_VERSION}/Electrum-MONA-${ELECTRUM_VERSION}.tar.gz.sig -O Electrum-MONA-${ELECTRUM_VERSION}.tar.gz.sig
verify_with $ELECTRUM_GPG_FINGERPRINT Electrum-MONA-${ELECTRUM_VERSION}.tar.gz.sig

if [ $? != 0 ]; then
  exit 1
fi

echo "---> Get sha512 checksum"
checksum=`sha512sum Electrum-MONA-4.1.4.tar.gz | awk '{print $1}'`
echo "SHA512 Checksum: ${checksum}"
rm Electrum-MONA-${ELECTRUM_VERSION}.tar.gz
rm Electrum-MONA-${ELECTRUM_VERSION}.tar.gz.sig

echo $checksum > CHECKSUM_SHA512
echo $ELECTRUM_VERSION > VERSION

echo "---> Done!"