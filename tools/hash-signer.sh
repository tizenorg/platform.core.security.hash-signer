#/bin/bash

generateAuthorSig=0
generateDistSig=0
baseDir="./"
privilegeLevel="public"
authSignCert="/opt/usr/share/certs/signer/tizen_author.p12"
authSignCertPwd="tizenauthor"
distSignCertPwd="tizenpkcs12passfordsigner"

while getopts "adp:" o
do
    case "$o" in
    a) generateAuthorSig=1;;
    d) generateDistSig=1;;
    p) privilegeLevel=$OPTARG;;
    esac
done

shift $((OPTIND - 1))

ls $1
if test -e "$1"
then
    echo Base dir does not exist
#    exit 2
fi

baseDir="$1"

if [ "$privilegeLevel" == "partner" ]
then
	echo "Sign as partner level"
    distSignCert="/opt/usr/share/certs/signer/tizen-distributor-partner-signer.p12"
elif [ "$privilegeLevel" == "platform" ]
then
	echo "Sign as platform level"
	distSignCert="/opt/usr/share/certs/signer/tizen-distributor-partner-manufacturer-signer.p12"
else
    echo "Sign as public level"
	distSignCert="/opt/usr/share/certs/signer/tizen-distributor-public-signer.p12"
fi

if test "$generateAuthorSig" != "0"
then
    echo "Generate Author Signature"
	/usr/bin/sign-widget.sh --pkcs12 "$authSignCert" --pwd "$authSignCertPwd" -a -x "$baseDir"
fi

if test "$generateDistSig" != "0"
then
    echo "Generate Distributor Signature"
	/usr/bin/sign-widget.sh --pkcs12 "$distSignCert" --pwd "$distSignCertPwd" -x "$baseDir"
fi
