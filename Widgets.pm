package Widgets;

use warnings;
use strict;
use Gtk;
use Math::ConvexHull qw(convex_hull);

# {{{ Widgets
# {{{ new
sub new {
  my $proto = shift;
  my $radius = shift || 10;
  my $width = shift || 500;
  my $height = shift || 500;
  my $class = ref $proto || $proto;
  bless {
    radius => $radius,
    pixmap => {
      width => $width,
      height => $height,
    },
  },$class;
}
# }}}
# {{{ attract_vertex
sub attract_vertex {
  my ($self,$heap,$vertex) = @_;
  my $two_r = $self->{radius} * 2;
  $vertex->[0] = 0 if $vertex->[0] < $two_r;
  $vertex->[1] = 0 if $vertex->[1] < $two_r;
  $vertex->[0] = $heap->{pane}{width}
    if $vertex->[0] > $heap->{pane}{width} - $two_r;
  $vertex->[1] = $heap->{pane}{height}
    if $vertex->[1] > $heap->{pane}{height} - $two_r;

  my ($c_x,$c_y) = ($heap->{pane}{width}/2,$heap->{pane}{height}/2);
  $vertex->[0] = $c_x
    if $vertex->[0] >= $c_x-$self->{radius} and
       $vertex->[0] <= $c_x+$self->{radius};
  $vertex->[1] =$c_y
    if $vertex->[1] >= $c_y-$self->{radius} and
       $vertex->[1] <= $c_y+$self->{radius};
}
# }}}
# {{{ draw_dashed_line
sub draw_dashed_line {
  my ($self,$widget,$pixmap,$v1,$v2) = @_;
  my $dash_context = Gtk::Gdk::GC->new($widget->window);
  my $blue_color =
    $widget->window->get_colormap->color_alloc({
      red => 0, green => 0, blue => 65535,
    });
  $dash_context->set_foreground($blue_color);
  $dash_context->set_line_attributes(1,'on-off-dash','not-last','miter');
  $pixmap->draw_line( $dash_context, @{$v1}, @{$v2} );
}
# }}}
# {{{ draw_vertices
sub draw_vertices {
  my ($self,$heap,$widget) = @_;
  return if $heap->{vertex_list}->empty();
my $old_pixmap = $heap->{vertex_list}->{pixmap};
$heap->{vertex_list}->pixmap($widget);
  for(my $i=0;$i<$heap->{vertex_list}->count();$i++) {
    my $selected;
    next if defined $heap->{drag_mode}
      and $heap->{drag_mode} eq 'drag'
      and $i == $heap->{drag_vertex};
    $selected = 1 if
      defined $heap->{drag_mode} and
      $heap->{drag_mode} eq 'stretch' and
      $heap->{drag_vertex};
    $heap->{vertex_list}->draw($i,$selected);
  }
$heap->{vertex_list}->pixmap($old_pixmap);
}
# }}}
# {{{ Edge drawing
# {{{ draw_edges
sub draw_edges {
  my ($self,$heap,$widget,$pixmap) = @_;
  return unless defined $heap->{edge} and @{$heap->{edge}}>0;
  for(my $i=0;$i<@{$heap->{edge}};$i++) {
    my $edge = $heap->{edge}[$i];
    next if defined $heap->{drag_mode}
      and $heap->{drag_mode} eq 'drag'
      and ($heap->{drag_vertex} == $edge->[0] or
           $heap->{drag_vertex} == $edge->[1]);
    $self->draw_dashed_line(
      $widget,
      $pixmap,
      $heap->{vertex_list}->location($edge->[0]),
      $heap->{vertex_list}->location($edge->[1]),
    );
  }
}
# }}}
# {{{ draw_active_edges
sub draw_active_edges {
  my ($self,$heap,$widget,$pixmap,$vertex) = @_;
  return unless defined $heap->{edge} and @{$heap->{edge}}>0;
  for(my $i=0;$i<@{$heap->{edge}};$i++) {
    my $edge = $heap->{edge}[$i];
    next unless $edge->[0] == $vertex or $edge->[1] == $vertex;
    $self->draw_dashed_line(
      $widget,
      $pixmap,
      $heap->{vertex_list}->location($edge->[0]),
      $heap->{vertex_list}->location($edge->[1]),
    );
  }
}
# }}}
# }}}
# {{{ backdrop
sub backdrop {
  my ($self,$pixmap,$widget) = @_;
  my ($w,$h) = ($self->{pixmap}{width},$self->{pixmap}{height});

  $pixmap->draw_rectangle( $widget->style->white_gc, 1, 0,0, $w,$h );
  $self->draw_dashed_line( $widget,$pixmap, [($w/2), 0], [($w/2),$h] );
  $self->draw_dashed_line( $widget,$pixmap, [0, ($h/2)], [$w,($h/2)] );
}
# }}}
# {{{ Backing pixmap
# {{{ create_backing
sub create_backing {
  my ($self,$heap,$widget) = @_;
  $heap->{temp_pixmap} =
    Gtk::Gdk::Pixmap->new(
      $widget->window,
      $heap->{pane}{width},$heap->{pane}{height}
      -1
    );
  $self->backdrop($heap->{temp_pixmap},$widget);
  $self->draw_vertices($heap,$heap->{temp_pixmap});
  $self->draw_edges($heap,$widget,$heap->{temp_pixmap});
}
# }}}
# {{{ copy_backing
sub copy_backing {
  my ($self,$heap) = @_;
  $heap->{pixmap}->draw_pixmap(
    $heap->{gc}{black},
    $heap->{temp_pixmap},
    0,0,
    0,0,
    $heap->{pane}{width},$heap->{pane}{height}
  );
}
# }}}
# }}}
# }}}

1;

__END__

=pod

=head1 NAME

MyWidgets - Just an arbitrary file to store local widgets

=head1 SYNOPSIS

 use MyWidgets;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@cpan.org>

=cut
