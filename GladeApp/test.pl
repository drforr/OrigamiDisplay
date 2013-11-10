#!/usr/bin/perl
#==============================================================================
#=== This is a toplevel script
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

package app1;

BEGIN {
    use lib "./";
    use src::NetDisplay;
    use vars qw(@ISA);
#    use Carp qw(cluck);
#        $SIG{__DIE__}  = &Carp::confess;
#        $SIG{__WARN__} = &Carp::cluck;
}

$Glade::PerlRun::pixmaps_directory = "/home/jgoff/Projects/NetDisplay/pixmaps";

select STDOUT; $| = 1;

my %params = (
);

__PACKAGE__->app_run(%params) && exit 0;

exit 1;

1;

__END__
}
