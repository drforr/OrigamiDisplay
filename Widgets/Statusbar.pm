package Widgets::Statusbar;

use warnings;
use strict;

use vars '@ISA';
@ISA=qw(Gtk::Statusbar);

sub new {
  my $proto   = shift;
  my $heap    = shift;
  my $class = ref $proto || $proto;

  my $widget = Gtk::Statusbar->new();
  $heap->{statusbar_count} = 0;
  $heap->{statusbar_context} =
    $widget->get_context_id('MeshDisplay status');
  $heap->{box}->pack_start($widget, 0, 0, 0);
  
  bless $widget,$class;
}

1;

__END__

=pod

=head1 NAME

Widgets::StatusBar - Container for scrollable text

=head1 SYNOPSIS

 use Widgets::StatusBar;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
