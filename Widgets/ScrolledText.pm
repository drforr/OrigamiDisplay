package Widgets::ScrolledText;

use warnings;
use strict;

use vars '@ISA';
@ISA=qw(Gtk::Table);

sub new {
  my $proto = shift;
  my $session = shift;
  my $class = ref $proto || $proto;

  # Create a table to hold the text widget and scrollbars
  my $widget = Gtk::Table->new( 2, 2, 0 );

  # Put a text widget in the upper left hand corner. Note the use of
  # 'shrink' in the y direction
  my $text = new Gtk::Text( "", "" );
  $widget->attach( $text, 0, 1, 0, 1,
		  [ 'fill', 'expand' ],
		  [ 'fill', 'expand', 'shrink' ],
		  0, 0 );
  $text->show();

  # Put a HScrollbar in the lower left hand corner
  my $hscrollbar = new Gtk::HScrollbar( $text->hadj );
  $widget->attach( $hscrollbar, 0, 1, 1, 2,
		  [ 'expand', 'fill' ],
		  'fill', 0, 0 );
  $hscrollbar->show();

  # And a VScrollbar in the upper right
  my $vscrollbar = new Gtk::VScrollbar( $text->vadj );
  $widget->attach( $vscrollbar, 1, 2, 0, 1, 'fill',
		  [ 'expand', 'fill', 'shrink' ], 0, 0 );
  $vscrollbar->show();

  # Add a handler to put a message in the text widget when it is realized
  $text->signal_connect(
    'realize',
    $session->postback('ev_realize_text')
  );

  bless $widget,$class;
}

1;

__END__

=pod

=head1 NAME

Widget::ScrolledText - Container for scrollable text

=head1 SYNOPSIS

 use Widgets::ScrolledText;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
