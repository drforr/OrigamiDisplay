package Widgets::Paned;

use warnings;
use strict;

use vars '@ISA';
@ISA=qw(Gtk::HPaned);

sub new {
  my $proto = shift;
  my $class = ref $proto || $proto;

  my $widget = new Gtk::HPaned();
  $widget->set_handle_size(10);
  $widget->set_gutter_size(15);

  bless $widget,$class;
}

sub packStuff {
  my $self = shift;
  my $item1 = shift;
  my $item2 = shift;

  $self->pack1($item1,1,0);
  $self->pack2($item2,1,0);
}

1;

__END__

=pod

=head1 NAME

Widgets::Paned - Container for scrollable text

=head1 SYNOPSIS

 use Widgets::Paned;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
