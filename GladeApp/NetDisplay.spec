%define ver     0.01
%define rel     1
%define name    NetDisplay
%define rlname  %{name}
%define source0 http://%{name}-%{ver}.tar.gz
%define url     http://
%define group   Application
%define copy    GPL or Artistic
%define filelst %{name}-%{ver}-files
%define confdir /etc
%define prefix  /usr
%define arch    noarch

Summary: No description

Name: %name
Version: %ver
Release: %rel
Copyright: %{copy}
Packager: Jeff <jgoff@localhost.localdomain>
Source: %{source0}
URL: %{url}
Group: %{group}
BuildArch: %{arch}
BuildRoot: /var/tmp/%{name}-%{ver}

%description
No description

%prep
%setup -n %{rlname}-%{ver}

%build
if [ $(perl -e 'print index($INC[0],"%{prefix}/lib/perl");') -eq 0 ];then
    # package is to be installed in perl root
    inst_method="makemaker-root"
    CFLAGS=$RPM_OPT_FLAGS perl Makefile.PL PREFIX=%{prefix}
else
    # package must go somewhere else (eg. /opt), so leave off the perl
    # versioning to ease integration with automatic profile generation scripts
    # if this is really a perl-version dependant package you should not omiss
    # the version info...
    inst_method="makemaker-site"
    CFLAGS=$RPM_OPT_FLAGS perl Makefile.PL PREFIX=%{prefix} LIB=%{prefix}/lib/perl5
fi

echo $inst_method > inst_method

# get number of processors for parallel builds on SMP systems
numprocs=`cat /proc/cpuinfo | grep processor | wc | cut -c7`
if [ "x$numprocs" = "x" -o "x$numprocs" = "x0" ]; then
  numprocs=1
fi

make "MAKE=make -j$numprocs"

%install
rm -rf $RPM_BUILD_ROOT

if [ "$(cat inst_method)" = "makemaker-root" ];then
   make UNINST=1 PREFIX=$RPM_BUILD_ROOT%{prefix} install
elif [ "$(cat inst_method)" = "makemaker-site" ];then
   make UNINST=1 PREFIX=$RPM_BUILD_ROOT%{prefix} LIB=$RPM_BUILD_ROOT%{prefix}/lib/perl5 install
fi

%__os_install_post
find $RPM_BUILD_ROOT -type f -print|sed -e "s@^$RPM_BUILD_ROOT@@g" > %{filelst}

%files -f %{filelst}
%defattr(-, root, root)
%doc Documentation/*

%clean
rm -rf $RPM_BUILD_ROOT

%changelog
* Tue Sep 24 2002 - Jeff <jgoff@localhost.localdomain>
    This file was created by Glade::PerlSource
