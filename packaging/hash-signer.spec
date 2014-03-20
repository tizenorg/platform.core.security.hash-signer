Name:       hash-signer
Summary:    Commandline tool for Tizen Signing
Version:    0.0.1
Release:    0
Group:      Security/Development
License:    Apache-2.0
Source0:    %{name}-%{version}.tar.gz
BuildRequires: xmlsec1
BuildRequires: libtzplatform-config-devel
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

mkdir -p %{buildroot}%{TZ_SYS_SHARE}/certs/signer
cp -arf certificates/* %{buildroot}%{TZ_SYS_SHARE}/certs/signer/
mkdir -p %{buildroot}%{_bindir}
cp -arf tools/* %{buildroot}%{_bindir}/
mkdir -p %{buildroot}%{_sysconfdir}/rpm
cp -arf macros/* %{buildroot}%{_sysconfdir}/rpm/

%files
%defattr(-,root,root,-)
%{TZ_SYS_SHARE}/certs/signer/*
%{_bindir}/*
%{_sysconfdir}/rpm/*
