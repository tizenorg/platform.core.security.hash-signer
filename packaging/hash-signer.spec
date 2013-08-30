Name:       hash-signer
Summary:    Commandline tool for Tizen Signing
Version:    0.0.1
Release:    2
Group:      Productivity/Security
License:    Apache-2.0
Source0:    %{name}-%{version}.tar.gz
BuildRequires: xmlsec1
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
rm -rf %{buildroot}

mkdir -p %{buildroot}/opt/usr/share/certs/signer
cp -arf certificates/* %{buildroot}/opt/usr/share/certs/signer/
mkdir -p %{buildroot}/usr/bin
cp -arf tools/* %{buildroot}/usr/bin/
mkdir -p %{buildroot}/etc/rpm
cp -arf macros/* %{buildroot}/etc/rpm/

%files
%defattr(-,root,root,-)
/opt/usr/share/certs/signer/*
/usr/bin/*
/etc/rpm/*
