#/bin/bash
source /etc/tizen-platform.conf

generateAuthorSig=0
generateDistSig=0
baseDir="./"
privilegeLevel="public"
authSignCert="${TZ_USER_SHARE}/certs/signer/tizen_author.p12"
authSignCertPwd="tizenauthor"
distSignCertPwd="tizenpkcs12passfordsigner"
buildRootDir=""

while getopts "ab:dp:" o
do
    case "$o" in
    a) generateAuthorSig=1;;
    b) buildRootDir=$OPTARG;;
    d) generateDistSig=1;;
    p) privilegeLevel=$OPTARG;;
    esac
done

shift $((OPTIND - 1))

OIFS=$IFS
IFS=';'
baseDirs=$1

for tempBaseDir in $baseDirs
do

    baseDir="$buildRootDir/$tempBaseDir"
	if ! test -e "$baseDir"
	then
		echo Base dir does not exist
		exit 2
	fi

	if [ "$privilegeLevel" == "partner" ]
	then
		echo "Sign as partner level"
		distSignCert="${TZ_USER_SHARE}/certs/signer/tizen-distributor-partner-signer.p12"
	elif [ "$privilegeLevel" == "platform" ]
	then
		echo "Sign as platform level"
		distSignCert="${TZ_USER_SHARE}/certs/signer/tizen-distributor-partner-manufacturer-signer.p12"
	else
		echo "Sign as public level"
		distSignCert="${TZ_USER_SHARE}/certs/signer/tizen-distributor-public-signer.p12"
	fi

	if test "$generateAuthorSig" != "0"
	then
		echo "Generate Author Signature"
		${TZ_SYS_BIN}/sign-widget.sh --pkcs12 "$authSignCert" --pwd "$authSignCertPwd" -a -x "$baseDir"
	fi

	if test "$generateDistSig" != "0"
	then
		echo "Generate Distributor Signature"
		${TZ_SYS_BIN}/sign-widget.sh --pkcs12 "$distSignCert" --pwd "$distSignCertPwd" -x "$baseDir"
	fi
done
