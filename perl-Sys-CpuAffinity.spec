Name:           perl-Sys-CpuAffinity
Version:        1.12
Release:        1%{?dist}
Summary:        Sys::CpuAffinity - Set CPU affinity for processes

License:        GPL-1.0-or-later OR Artistic-1.0-Perl
URL:            http://search.cpan.org/dist/Sys-CpuAffinity/
Source0:        https://cpan.metacpan.org/authors/id/M/MO/MOB/Sys-CpuAffinity-%{version}.tar.gz

#BuildArch:      
BuildRequires:  perl
# Remove "BuildRequires:  perl-devel" for noarch packages (unneeded)
BuildRequires:  perl-devel
BuildRequires:  perl-generators
# Correct for lots of packages, other common choices include eg. Module::Build
BuildRequires:  perl(ExtUtils::MakeMaker)
Requires:  perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%{?perl_default_filter}

%description
The details of getting and setting process CPU affinities varies greatly from
system to system. Even among the different flavors of Unix there is very
little in the way of a common interface to CPU affinities. The existing tools
and libraries for setting CPU affinities are not very standardized, so that a
technique for setting CPU affinities on one system may not work on another
system with the same architecture.
.
Sys::CpuAffinity seeks to do one thing and do it well: manipulate CPU
affinities through a common interface on as many systems as possible, by any
means necessary.
.
The module is composed of several subroutines, each one implementing a
different technique to perform a CPU affinity operation. A technique might
try to import a Perl module, run an external program that might be installed
on your system, or invoke some C code to access your system libraries.
Usually, a technique is applicable to only a single or small group of
operating systems, and on any particular system, the vast majority of
techniques would fail. Regardless of your particular system and
configuration, it is hoped that at least one of the techniques will work and
you will be able to get and set the CPU affinities of your processes.


%prep
%autosetup -n Sys-CpuAffinity-%{version}


%build
# Remove OPTIMIZE=... from noarch packages (unneeded)
%{__perl} Makefile.PL INSTALLDIRS=vendor OPTIMIZE="$RPM_OPT_FLAGS"
%make_build


%install
make pure_install DESTDIR=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} ';'
# Remove the next line from noarch packages (unneeded)
find $RPM_BUILD_ROOT -type f -name '*.bs' -a -size 0 -exec rm -f {} ';'
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null ';'
%{_fixperms} $RPM_BUILD_ROOT/*


%check
make test


%files
%doc Changes README
%{perl_vendorarch}/*
%exclude %dir %{perl_vendorarch}/auto/
%{_mandir}/man3/*.3*


%changelog
* Fri Dec 26 2025 Philippe Coval <philippe.coval@vates.tech> 1.12-1
- Initial Fedora RPM version
