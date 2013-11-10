package Widgets::DrawingArea;

use warnings;
use strict;

use vars '@ISA';
@ISA=qw(Gtk::Table);

sub __drawing_area {
  my ($session,$heap,$parent) = @_;
  # Create the drawing area.
  my $widget = new Gtk::DrawingArea();
  $widget->size(
    $heap->{pane}{width},
    $heap->{pane}{height}
  );
  $parent->attach(
    $widget,
    1, 2, 1, 2,
    [ 'expand', 'shrink', 'fill' ],
    [ 'fill' ],
    0, 0
  );
  $widget->set_events( [
    'pointer_motion_mask',
    'pointer_motion_hint_mask',
    'button_press_mask',
    'button_release_mask',
    'exposure_mask',
  ] );
  $widget->signal_connect(
    'button_press_event',
    $session->postback('ev_button_press')
  );
  $widget->signal_connect(
    'motion_notify_event',
    $session->postback('ev_motion_notify')
  );
  $widget->signal_connect(
    'button_release_event',
    $session->postback('ev_button_release')
  );
  $widget->signal_connect(
    'expose_event',
    $session->postback('ev_exposure')
  );
  $widget->signal_connect(
    'realize',
    $session->postback('ev_realize')
  );
  $widget->show();
  $widget;
}

sub new {
  my $proto   = shift;
  my $session = shift;
  my $heap    = shift;
  my $class = ref $proto || $proto;

  # Create a table for placing the ruler and the drawing area
  my $widget = new Gtk::Table( 3, 2, 0 );

  $heap->{area} = __drawing_area($session,$heap,$widget);

  # The horizontal ruler goes on top. As the mouse moves across the
  # drawing area, a motion_notify_event is passed to the
  # appropriate event handler for the ruler.
  $heap->{ruler}{horizontal} = new Gtk::HRuler();
  $heap->{ruler}{horizontal}->set_metric( 'pixels' );
  $heap->{ruler}{horizontal}->set_range(
    0, $heap->{pane}{width},
    0, $heap->{pane}{height}
  );
  $heap->{area}->signal_connect(
    "motion_notify_event",
    $session->postback('ev_hrule_motion')
  );
  $widget->attach(
    $heap->{ruler}{horizontal},
    1, 2, 0, 1,
    [ 'expand', 'shrink', 'fill' ],
    [ 'fill' ],
    0, 0
  );

  # The vertical ruler goes on the left. As the mouse moves across
  # the drawing area, a motion_notify_event is passed to the
  # appropriate event handler for the ruler.
  $heap->{ruler}{vertical} = new Gtk::VRuler();
  $heap->{ruler}{vertical}->set_metric( 'pixels' );
  $heap->{ruler}{vertical}->set_range(
    0, $heap->{pane}{width},
    0, $heap->{pane}{height}
  );
  $heap->{area}->signal_connect(
    "motion_notify_event",
    $session->postback('ev_vrule_motion')
  );
  $widget->attach(
    $heap->{ruler}{vertical},
    0, 1, 1, 2,
    [ 'fill' ],
    [ 'expand', 'shrink', 'fill' ],
    0, 0
  );

  # Now show everything
  $heap->{area}->show();
  $heap->{ruler}{horizontal}->show();
  $heap->{ruler}{vertical}->show();
  $widget->show();

  bless $widget,$class;
}

1;

__END__

=pod

=head1 NAME

Widget::DrawingArea - Container for scrollable text

=head1 SYNOPSIS

 use Widgets::DrawingArea;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
