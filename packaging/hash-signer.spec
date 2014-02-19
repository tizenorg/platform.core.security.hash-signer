Name:       hash-signer
Summary:    Commandline tool for Tizen Signing
Version:    0.0.1
Release:    2
Group:      Productivity/Security
License:    Apache-2.0
Source0:    %{name}-%{version}.tar.gz
BuildRequires: xmlsec1
BuildRequires: pkgconfig(libtzplatform-config)

Requires:   libtzplatform-config
Requires:   xmlstarlet
Requires:   xmlsec1
Requires:   zip
Requires:   unzip
%description
hash-signer is command line signing tool for OBS/GBS. It generates signature
files in OBS/GBS build time. Refer to signature spec  http://www.w3.org/TR/widgets-digsig.

%prep
%setup -q

%build


%install
source /etc/tizen-platform.conf
rm -rf %{buildroot}

mkdir -p %{buildroot}${TZ_USER_SHARE}/certs/signer
cp -arf certificates/* %{buildroot}${TZ_USER_SHARE}/certs/signer/
mkdir -p %{buildroot}${TZ_SYS_BIN}
cp -arf tools/* %{buildroot}${TZ_SYS_BIN}/
mkdir -p %{buildroot}/etc/rpm
cp -arf macros/* %{buildroot}/etc/rpm/

%files
%defattr(-,root,root,-)
/opt/usr/share/certs/signer/*
%{TZ_SYS_BIN}/*
/etc/rpm/*
