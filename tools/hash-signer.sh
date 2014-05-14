#!/bin/bash

# Set the TZ_XXX_YYY variables required for multi-user support
source /etc/tizen-platform.conf

generateAuthorSig=0
generateDistSig=0
baseDir="./"
privilegeLevel="public"
authSignCert="$TZ_SYS_SHARE/certs/signer/tizen_author.p12"
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
		distSignCert="$TZ_SYS_SHARE/certs/signer/tizen-distributor-partner-signer.p12"
	elif [ "$privilegeLevel" == "platform" ]
	then
		echo "Sign as platform level"
		distSignCert="$TZ_SYS_SHARE/certs/signer/tizen-distributor-partner-manufacturer-signer.p12"
	else
		echo "Sign as public level"
		distSignCert="$TZ_SYS_SHARE/certs/signer/tizen-distributor-public-signer.p12"
	fi

	if test "$generateAuthorSig" != "0"
	then
		echo "Generate Author Signature"
		rm -rf "$baseDir/author-signature.xml"
		/usr/bin/sign-widget.sh --pkcs12 "$authSignCert" --pwd "$authSignCertPwd" -a -x "$baseDir"
	fi

	if test "$generateDistSig" != "0"
	then
		echo "Generate Distributor Signature"
		rm -rf "$baseDir/signature*.xml"
		/usr/bin/sign-widget.sh --pkcs12 "$distSignCert" --pwd "$distSignCertPwd" -x "$baseDir"
	fi
done
