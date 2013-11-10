package Widgets::MainWindow;

use warnings;
use strict;

use vars '@ISA';
@ISA=qw(Gtk::Window);

sub new {
  my $proto   = shift;
  my $kernel = shift;
  my $heap    = shift;
  my $class = ref $proto || $proto;

  my $widget = Gtk::Window->new("toplevel");
  $widget->set_title("MeshDisplay");
  $kernel->signal_ui_destroy($widget);

  bless $widget,$class;
}

1;

__END__

=pod

=head1 NAME

Widgets::MainWindow - Container for scrollable text

=head1 SYNOPSIS

 use Widgets::MainWindow;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
