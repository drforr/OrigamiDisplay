package VertexList;

use warnings;
use strict;
use Gtk;
use Math::ConvexHull qw(convex_hull);

# {{{ new
sub new {
  my $proto = shift;
  my $widget = shift; # Strictly for the GC color
  my $radius = shift || 10;
  my $class = ref $proto || $proto;
  my $gray = 65535 * (5/8);
  my $self = {
    radius => $radius,
    widget => $widget,
    vertex => [],
    gc => {
      black => Gtk::Gdk::GC->new($widget->window),
      red   => Gtk::Gdk::GC->new($widget->window),
      gray  => Gtk::Gdk::GC->new($widget->window),
    },
  };
  $self->{gc}{red}->set_foreground(
    $widget->window->get_colormap->color_alloc({red=>65535,green=>0,blue=>0})
  );
  $self->{gc}{gray}->set_foreground(
    $widget->window->get_colormap->color_alloc({
      red => $gray, green => $gray, blue => $gray,
    })
  );
  bless $self,$class;
}
# }}}
# {{{ empty()
sub empty {
  my ($self) = @_;
  return scalar @{$self->{vertex}} == 0;
}
# }}}
# {{{ pixmap([$pixmap])
sub pixmap {
  my $self = shift;
  $self->{pixmap} = shift if defined $_[0];
  return $self->{pixmap};
}
# }}}
# {{{ add($x,$y)
sub add {
  my ($self,$x,$y) = @_;
  push @{$self->{vertex}},[$x,$y];
}
# }}}
# {{{ move($id,$x,$y)
sub move {
  my ($self,$id,$x,$y) = @_;
  $self->{vertex}[$id]=[$x,$y];
}
# }}}
# {{{ select($id)
sub select {
  my ($self,$x,$y) = @_;
  for(0..$#{$self->{vertex}}) {
    next unless abs($x-$self->{vertex}[$_][0]) < $self->{radius};
    next unless abs($y-$self->{vertex}[$_][1]) < $self->{radius};
    return $_;
  }
  return;
}
# }}}
# {{{ location($id)
sub location {
  my ($self,$id) = @_;
  if($self->empty()) {
    my ($package,$filename,$line) = caller;
    die "location() called on empty VertexList from line $line, file $filename.\n";
  }
  if(ref $id) {
    my ($package,$filename,$line) = caller;
    die "location() called with strange id from line $line of $filename.\n";
  }
  if($id < 0 or $id > $self->last()) {
    my ($package,$filename,$line) = caller;
    die "location() called with invalid id $id from line $line of $filename.\n";
  }
  return $self->{vertex}[$id];
}
# }}}
# {{{ count()
sub count {
  my ($self) = @_;
  return scalar @{$self->{vertex}};
}
# }}}
# {{{ last()
sub last {
  my ($self) = @_;
  return $#{$self->{vertex}};
}
# }}}
# {{{ draw($id,$selected)
sub draw {
  my ($self,$id,$selected) = @_;
  $self->draw_loc($self->location($id),$selected);
}
# }}}
# {{{ draw_loc($v_ref,$selected)
sub draw_loc {
  my ($self,$v_ref,$selected) = @_;
  my ($x,$y)=@$v_ref;
#  $pixmap->draw_string(
#    $heap->{font},
#    $heap->{gc}{black},
#    $x,$y,
#    $idx+1
#  );
  $self->{pixmap}->draw_line(
    $self->{gc}{black},
    $x-$self->{radius},$y,
    $x+$self->{radius},$y,
  );
  $self->{pixmap}->draw_line(
    $self->{gc}{black},
    $x,$y-$self->{radius},
    $x,$y+$self->{radius},
  );
  if(defined $selected) {# and $selected == 1) {
    $self->{pixmap}->draw_rectangle(
      $self->{gc}{red},
      0,
      $x-$self->{radius},$y-$self->{radius},
      $self->{radius}*2,$self->{radius}*2
    );
  }
}
# }}}
# {{{ draw_hull($widget,$pixmap)
sub draw_hull {
  my ($self,$widget,$pixmap) = @_;
  my $count = $self->count();
  return unless $count >= 3;

  if($count == 3) {
    for(0..2) {
      $pixmap->draw_line(
        $self->{gc}{gray},
        @{$self->{vertex}[$_]},
        @{$self->{vertex}[($_+1)%3]}
      );
    }
  }
  else {
    my $hull = convex_hull($self->{vertex});
    for(my $i=0;$i<@$hull;$i++) {
      $pixmap->draw_line(
        $self->{gc}{gray},
        @{$hull->[$i]},
        @{$hull->[($i+1)%@$hull]},
      );
    }
  }
}
# }}}

1;

__END__

=pod

=head1 NAME

VertexList - Keep track of the list of vertices

=head1 SYNOPSIS

 use VertexList;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@cpan.org>

=cut
