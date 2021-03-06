#
#   Makefile.PL for NetDisplay
#    - version 0.01 - This file was created by Glade::PerlSource
#
require 5.000;
use ExtUtils::MakeMaker;
use strict;

#--- Configuration section ---

my @programs_to_install = qw();

my @need_perl_modules = (
    # Check for Gtk::Types rather than the Gtk supermodule
    #   this avoids dumping MakeMaker
    {'name'     => 'Gtk',
    'test'      => 'Gtk::Types',
    'version'   => '0.7000',
    'reason'    => "implements the perl bindings to Gtk+.\n".
                    "The module is called Gtk-Perl on CPAN or ".
                    "module gnome-perl in the Gnome CVS"},

    # Check for Gnome::Types rather than the Gnome supermodule
    #   this avoids dumping MakeMaker
    {'name'     => 'Gnome',
    'test'      => 'Gnome::Types',
    'version'   => '1.2.0',
    'reason'    => "implements the perl bindings to Gnome.\n".
                   "It is a submodule of the Gtk-Perl package and needs to be built separately.\n".
                   "Read the Gtk-Perl INSTALL file for details of how to do this.\n".
                   "Glade-Perl will still work but you will not be able to \n".
                   "use any Gnome widgets in your Glade projects"},
    );
#--- End Configuration - You should not have to change anything below this line

# Allow us to suppress all program installation with the -n (library only)
# option.  This is for those that don't want to mess with the configuration
# section of this file.
use Getopt::Std;
use vars qw($opt_n);
unless (getopts("n")) {
    die "Usage: $0 [-n]\n";
}
@programs_to_install = () if $opt_n;

# Check for non-standard modules that are used by this library.
$| = 1; # autoflush on
my $missing_modules = 0;

foreach my $mod (@need_perl_modules) {
    print "Checking for $mod->{'name'}..";
    eval "require $mod->{'test'}";
    if ($@) {
        $missing_modules++;
        print " failed\n";
        print   "-------------------------------------------------------".
                "\n$@\n",
                "$mod->{'name'} is needed, it $mod->{'reason'}\n",
                "We need at least version $mod->{'version'}\n".
                "-------------------------------------------------------\n";
        sleep(2);  # Don't hurry too much
    } else {
        print " ok\n";
    }
}

#--------------------------------------
print "-------------------------------------------------------
The missing modules can be obtained from CPAN. Visit
<URL:http://www.perl.com/CPAN/> to find a CPAN site near you.
-------------------------------------------------------\n\n"
     if $missing_modules;

#--------------------------------------
# Last of all generate the Makefile
WriteMakefile(
    'DISTNAME'     => 'NetDisplay',
    'NAME'         => 'src',
    'VERSION_FROM' => 'src/NetDisplayUI.pm',
    'EXE_FILES'    => [ @programs_to_install ],
    'clean'        => { FILES => '$(EXE_FILES)' },
    'dist'         => { COMPRESS => 'gzip', SUFFIX => 'gz' }
);

package MY;

# Pass Glade-Perl version number to pod2man
sub manifypods
{
    my $self = shift;
    my $ver = $self->{'VERSION'} || "";
    local($_) = $self->SUPER::manifypods(@_);
    s/pod2man\s*$/pod2man --release NetDisplay-$ver/m;
    $_;
}

exit(0);

# End of Makefile.PL
