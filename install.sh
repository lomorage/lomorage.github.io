#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin#
# Lomorage install script
#
# All this script does is determine your OS and/or distribution and then add the correct
# repository or download the correct package and install it. It then starts the service
DEB_BASE_URL='https://lomoware.lomorage.com/debian/'
LOMOD_PATH='/opt/lomorage/bin/lomod'

install_docker () {
}

echo
echo '*** Lomoware One Quick Install for Linux Systems. Refer https://lomorage.com/installation/ for other OS'
echo
echo '*** Tested distributions and architectures:'
echo '***   Debian (7+) on x86_64, x86, arm, and arm64'
echo
echo '*** Please report problems to support@lomorage.com and we will try to fix.'
echo

SUDO=
if [ "$UID" != "0" ]; then
	if [ -e /usr/bin/sudo -o -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo '*** This quick installer script requires root privileges.'
		exit 0
	fi
fi

# Detect already-installed on Linux
if [ -f $LOMOD_PATH ]; then
	echo '*** Lomorage appears to already be installed.'
	exit 0
fi

rm -f /tmp/lomo-gpg-key
echo '-----BEGIN PGP PUBLIC KEY BLOCK-----' >/tmp/lomo-gpg-key
cat >>/tmp/lomo-gpg-key << END_OF_KEY
Version: GnuPG v1

mQINBFwGEbIBEAC9vQ7aOmWgrlSX75X6ytYBsu31PxF/qTJKiuMST+FXJb+ug4aa
hwLG2GEYVvaZBDtnDVR2CJGfbjwIrNH2u+gjSZMKDY+XYW3SmBGGFYHT4ZOWSGar
1owO+c1927HOrgHEmorha3FAtEOiKuIf6oMWsUTbAZY5sj37IgTrEJu9uA7WWxD7
D9J9AK0EIgNUBtcCVsgPWyvBgjqrua3CW2aQc/v7n+DiOPcJGvlZ9Oy3OumTPmJZ
tCbqkwIHyKs0lyT67sG0WShV/Kwq2NMiFrXRZ7oyFk5ikBmN+MEA2IYeGlRvl7+a
w4wtMXYLBLTkNhg8m9giQNkhRn4Nm3q39p11OXbtb1tojKQkMDQvPcFxVR8urWLM
vJOISTfw+lS+5FmUlc10XOe4olM3iLsaWBjVcq7+/kbgpEY437SAjsYivy5WNdES
L3KC4UOu806ih+yhbI9Rsbfm5OGSn3k4AQJZcAgFklcOui63Bs5gpXlwmMIjeVzJ
nb0gBbc6FURnjWZeFE+Dg0/bZ82sG7MUPsngYZk3s2+Ulw87r/2DpSsAQ9BnDVl+
yYnUsCuYRHSvuVBpEFotRjN4nQZY0CwkQUaHddmo/yyfTKXGthj93OpjfUElDFpY
nZBFcd1+jQG4qtHf7ZK/ufpBUvbHVloQq5MSrUOwuUqvWvzQNcfXxn7VoQARAQAB
tB1Mb21vcmFnZSA8bG9tb3JhZ2VAZ21haWwuY29tPokCOAQTAQIAIgUCXAYRsgIb
AwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQu3aCdvPg4s2lVA/+L0rgrwIv
Mu80RTw8TruqW7ktTr34R4BmB0/K0LBBrP2NczlwerZWf8eg93SLQrOWMq5p1J0X
hUWD2SwBM94gIQVW34jb5p8lZi5XvtyBc0WnTuiZkD1RAoV7LbjzqZ6exUwgYqcf
rBKlr+b4V5Lxyv7DuvbOSqekDmYujI8Q+B1OIJJNuQfI4TqyvO8/dZmEkBxE//mC
oNqYdOfrf1k9RZEqDn4XGOOQyIF/w6g8cakiOxoisKITIbDQTXKXR8QlaVd4qo04
0hcK8N4/JtmmqaHLAHu6Ap1E1jzresYedUG9tV+nWNvYkGe5rGY7QG8Tm7+cJ19P
c0I6W2+BHJFiuV15LgEkQeyS7ckGRl8EFUNX2zuId7tkJC1d8jOtn0X3jkm9af+O
bCoayIqC8fs0YW2vCM0VD39Y3MkifjizlOeGoGkq6iX4TM5kudRO2+W506uy5u3/
+oJpsg6GLCPQESxXOOzZfd+5X1BkUYnvvLCCoZplmzVv0fQq5utJt22i2jYoxfJ6
lqAgewqBvQgNAJ8MUTSkZrB6azG1DmiovD/IZbWoQgGyc0IEUB0FFK4OxehG4fcY
Cu3JL7Gndp9JWXxA5WoRYi9s73cfSbwUxfrp8LdJi1bI8cwm755ucYKiCaJi5dr5
GVMFrZA3ZOpbo124dP4c6u2Tn5eBtAw+p7E=
=qO+d
END_OF_KEY
echo '-----END PGP PUBLIC KEY BLOCK-----' >>/tmp/lomo-gpg-keyecho '*** Detecting Linux Distribution'
echo

if [ -f /etc/debian_version ]; then
	dvers=`cat /etc/debian_version | cut -d '.' -f 1 | cut -d '/' -f 1`
	$SUDO rm -f /tmp/lomo-sources-list	if [ -f /etc/lsb-release -a -n "`cat /etc/lsb-release 2>/dev/null | grep -F focal`" ]; then
		echo '*** Found Ubuntu "focal", creating /etc/apt/sources.list.d/lomoware.list'
		echo "deb ${DEB_BASE_URL}focal focal main" >/tmp/lomo-sources-list
	elif [ -f /etc/lsb-release -a -n "`cat /etc/lsb-release 2>/dev/null | grep -F groovy`" ]; then
		echo '*** Found Ubuntu "groovy", creating /etc/apt/sources.list.d/lomoware.list'
		echo "deb ${DEB_BASE_URL}groovy groovy main" >/tmp/lomo-sources-list
	elif [ "$dvers" = "buster" ]; then
		echo '*** Found Debian "buster", creating /etc/apt/sources.list.d/lomoware.list'
		echo "deb ${DEB_BASE_URL}buster buster main" >/tmp/lomo-sources-list
	else
		echo "*** WARNING: unrecognized distribution: $dvers. Try to install via Docker"
    install_docker
    exit 0
	fi
  $SUDO mv -f /tmp/lomo-sources-list /etc/apt/sources.list.d/lomoware.list
	$SUDO chown 0 /etc/apt/sources.list.d/lomoware.list
	$SUDO chgrp 0 /etc/apt/sources.list.d/lomoware.list
	$SUDO apt-key add /tmp/lomo-gpg-key	echo
	echo '*** Installing lomorage package...'	cat /dev/null | $SUDO apt-get update
	cat /dev/null | $SUDO apt-get install -y lomo-base lomo-vips lomo-backend lomo-web
fi

$SUDO rm -f /tmp/lomo-gpg-key

if [ ! -e $LOMOD_PATH ]; then
	echo
	echo '*** Package installation failed! Unfortunately there may not be a package'
	echo '*** for your architecture or distribution natively. Try to install via Docker'
  install_docker
  exit 0
fi

echo
echo '*** Enabling and starting lomorage service...'# restart lomod
$SUDO systemctl enable lomod
$SUDO systemctl restart lomod# restart lomo-web
$SUDO systemctl enable lomow
$SUDO systemctl restart lomow# restart lomo-frame
$SUDO service supervisor restart

echo
echo "*** Success! You can use mobile phone to discover lomo backend service now"
echo
