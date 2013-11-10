#!/usr/bin/perl
# $Id: skeleton.pl,v 1.16 2002/11/02 06:51:45 jgoff Exp $

use strict;
use warnings;
use FindBin;
use Gtk;
use POE qw(Wheel::ReadWrite Filter::Line Driver::SysRW Pipe::OneWay);
use VertexList;

use YAML;
use XML::LibXML;

use lib "$FindBin::Bin";
use Widgets; # Local widget collection
use Widgets::ScrolledText;
use Widgets::DrawingArea;
use Widgets::Statusbar;
use Widgets::Menubar;
use Widgets::MainWindow;
use Widgets::Paned;

# {{{ squared_length($v1,$v2)
sub squared_length {
  my ($v1,$v2) = @_;
  return abs($v1->[0]-$v2->[0])**2+abs($v1->[1]-$v2->[1]);
}
# }}}
# {{{ average(@list)
sub average {
  my $sum;
  for(@_) { $sum += $_ }
  return $sum/@_;
}
# }}}
# {{{ add_vec($v1,[$v|$v2]) returns $v
sub add_vec {
  my ($v1,$v2) = @_;
  if(ref $v2) {
    return [$v1->[0]+$v2->[0],$v1->[1]+$v2->[1]];
  }
  else {
    return [$v1->[0]+$v2,$v1->[1]+$v2];
  }
}
# }}}
# {{{ sub_vec($v1,[$v|$v2]) returns $v
sub sub_vec {
  my ($v1,$v2) = @_;
  if(ref $v2) {
    return [$v1->[0]-$v2->[0],$v1->[1]-$v2->[1]];
  }
  else {
    return [$v1->[0]-$v2,$v1->[1]-$v2];
  }
}
# }}}
# {{{ mul_vec($v1,[$v|$v2]) returns $v
sub mul_vec {
  my ($v1,$v2) = @_;
  if(ref $v2) {
    return [$v1->[0]*$v2->[0],$v1->[1]*$v2->[1]];
  }
  else {
    return [$v1->[0]*$v2,$v1->[1]*$v2];
  }
}
# }}}
# {{{ div_vec($v1,[$v|$v2]) returns $v
sub div_vec {
  my ($v1,$v2) = @_;
  if(ref $v2) {
    return [$v1->[0]/$v2->[0],$v1->[1]/$v2->[1]];
  }
  else {
    return [$v1->[0]/$v2,$v1->[1]/$v2];
  }
}
# }}}
# {{{ clamp_vertex($scaled_vertex)
# {{{ _clamp
sub _clamp {
  my $v = shift;
  return 0 if $v < 0;
  return 1 if $v > 1;
  $v;
}
# }}}
sub clamp_vertex {
  my $scaled_vertex = shift;
  for(0..$#{$scaled_vertex}) {
    $scaled_vertex->[$_][0] = _clamp($scaled_vertex->[$_][0]);
    $scaled_vertex->[$_][1] = _clamp($scaled_vertex->[$_][1]);
  }
}
# }}}

# {{{ neighbors($v_id,$edge_ref)
sub neighbors {
  my ($v_id,$edge_ref) = @_;
  my %neighbor;
  for(@$edge_ref) {
    $neighbor{$_->[1]}=undef if $v_id==$_->[0];
    $neighbor{$_->[0]}=undef if $v_id==$_->[1];
  }
  return keys %neighbor;
}
# }}}
# {{{ interior_nodes($v_list)
sub interior_nodes {
  my $v_list = shift;
  my $interior = [];
  for(0..$#{$v_list}) {
    next if $v_list->[$_][0]==0 or $v_list->[$_][0]==1;
    next if $v_list->[$_][1]==0 or $v_list->[$_][1]==1;
    push @$interior,$_;
  }
  $interior
}
# }}}
# {{{ perturb_vertex($v_ref,$leaf_list,$damping_factor)
sub perturb_vertex {
  my ($v,$leaf,$damping_factor) = @_; # Vertex to perturb, leaf nodes around it.
  my @s_length = map { squared_length($v,$_) } @$leaf;
  my $avg_length;
  for(@s_length) { $avg_length += $_ }
  $avg_length /= @s_length;
  my @correction = map { ($_-$avg_length)*$damping_factor } @s_length;
  for(0..$#correction) {
    $v = mul_vec(sub_vec($v,$leaf->[$_]),$correction[$_]);
  }
  return $v;
}
# }}}

# {{{ POE Sessions
POE::Session->create (
  inline_states => {
# {{{ _start
    _start => sub {
      my ($kernel, $session, $heap) = @_[KERNEL, SESSION, HEAP];
      $heap->{WIDGETS} = Widgets->new(10,500,500);
      $heap->{pane} = {
        width => 500,
        height => 500
      };
      $heap->{font} = Gtk::Gdk::Font->load('fixed');

      $heap->{main_window} = Widgets::MainWindow->new($kernel);

      $heap->{box} = Gtk::VBox->new(0, 0);

# {{{ menus
      my $local_menus = [
        'File' => [
          'New'     => undef,
          'Open'    => undef,
          'Save'    => undef,
          'Save As' => undef,
          'Close'   => undef,
          '_'       => undef,
          'Exit'    => 'ev_quit',
        ],
        'Edit' => [
          'Undo'  => undef,
          'Cut'   => undef,
          'Copy'  => undef,
          'Paste' => undef,
        ],
        'View' => [
          'Zoom In'  => undef,
          'Zoom Out' => undef,
        ],
        'Statusbar' => [
          'Test Push' => 'ev_push',
          'Test Pop'  => 'ev_pop',
        ],
      ];
# }}}

      $heap->{menubar} = Widgets::Menubar->new($session,$heap,$local_menus);

      my $list = Widgets::DrawingArea->new($session,$heap);
      my $text = Widgets::ScrolledText->new($session);

      $heap->{paned} = Widgets::Paned->new();
      $heap->{paned}->packStuff($list,$text);
      $heap->{box}->pack_start(
        $heap->{paned},
        1, 1, 2
      );
$heap->{optimize_btn} = Gtk::Button->new('Optimize');
$heap->{optimize_btn}->signal_connect('clicked',$session->postback('ev_optimize_toggle'));
$heap->{box}->pack_start($heap->{optimize_btn},1,1,2);

      $heap->{statusbar} = Widgets::Statusbar->new($heap);

      $heap->{main_window}->add($heap->{box});

$heap->{optimize_btn}->show();
      $list->show();
      $text->show();
      $heap->{paned}->show();
      $heap->{statusbar}->show();
      $heap->{box}->show();
      $heap->{main_window}->show();
      $heap->{vertex_list} = VertexList->new($heap->{main_window});
    },
# }}}

# {{{ ev_optimize_toggle
    ev_optimize_toggle => sub {
      my ($heap,$kernel,$session,$widget,$event) =
        (@_[HEAP,KERNEL,SESSION],$_[ARG1]->[0],$_[ARG1]->[1]);
      if($heap->{optimize_on}) {
        delete $heap->{optimize_on};
      }
      else {
        $heap->{optimize_on} = 10;
        $kernel->delay_set('ev_optimize_run',1);
        $heap->{WIDGETS}->create_backing($heap,$widget);
        $heap->{WIDGETS}->copy_backing($heap);
      }
    },
# }}}
# {{{ ev_optimize_run
    ev_optimize_run => sub {
      my ($heap,$kernel,$session) = @_[HEAP,KERNEL,SESSION];
      if($heap->{optimize_on} and $heap->{optimize_on} > 0) {
        $heap->{optimize_on}--;
      }
      else {
        $heap->{optimize_on}--;
        delete $heap->{optimize_on};
        return;
      }

      my @scaled_vertex =
        map { div_vec($heap->{vertex_list}->location($_),
                      [$heap->{pane}{width},
                       $heap->{pane}{height}]) } 0..$heap->{vertex_list}->count() - 1;
      my @edge_length =
        map { squared_length($scaled_vertex[$_->[0]],
                             $scaled_vertex[$_->[1]]) } @{$heap->{edge}};
      my $avg_squared_length = average(@edge_length);
      my $damping_factor = 0.1;
      my @compensation =
        map { $damping_factor * ($_-$avg_squared_length) } @edge_length;
# XXX Foolish assumption - that there's only one free vertex on the map
my $free_vertex = -1;
      for(0..$#scaled_vertex) {
        next if $scaled_vertex[$_][0]==0 or $scaled_vertex[$_][0]==1;
        next if $scaled_vertex[$_][1]==0 or $scaled_vertex[$_][1]==1;
        $free_vertex = $_; last;
      }
      
      for(@{$heap->{edge}}) {
        $scaled_vertex[$free_vertex] =
          add_vec($scaled_vertex[$free_vertex],
                  mul_vec(sub_vec($scaled_vertex[$_->[0]],
                                  $scaled_vertex[$_->[1]]),
                          $compensation[$_->[0]]));
      }
      clamp_vertex(\@scaled_vertex);
warn join(", ",@compensation)."\n";
      $heap->{vertex_list}->move($free_vertex,
                                 @{mul_vec($scaled_vertex[$free_vertex],
                                           [$heap->{pane}{width},
                                            $heap->{pane}{height}])});
my $widget = $heap->{main_window};
      $heap->{vertex_list}->draw_hull($widget,$heap->{pixmap});
      $heap->{vertex_list}->draw($free_vertex);
      $heap->{WIDGETS}->draw_active_edges(
         $heap,$widget,$heap->{pixmap},$free_vertex
      );
      $widget->draw();
      $kernel->delay_set('ev_optimize_run',1);
    },
# }}}

# {{{ ev_quit
    ev_quit  => sub { Gtk::main_quit; },
# }}}
# {{{ ev_hrule_motion
    ev_hrule_motion => sub {
      $_[HEAP]->{ruler}{horizontal}->motion_notify_event( $_[ARG1][1] );
    },
# }}}
# {{{ ev_vrule_motion
    ev_vrule_motion => sub {
      $_[HEAP]->{ruler}{vertical}->motion_notify_event( $_[ARG1][1] );
    },
# }}}
# {{{ ev_realize_text
    ev_realize_text => sub {
      my ($heap,$widget,$event) = ($_[HEAP],$_[ARG1]->[0],$_[ARG1]->[1]);

      $widget->freeze();
      $widget->insert(
        "",
        $widget->style->black, $widget->style->white,
<<_EOF_
From: pathfinder\@nasa.gov
To: mom\@nasa.gov
Subject: Made it!

We just got in this morning. The weather has been
great - clear but cold, and there are lots of fun
sights.
Sojourner says hi. See you soon.
 -Path
_EOF_
      );

      $widget->thaw();
    },
# }}}
# {{{ ev_button_press
    ev_button_press => sub {
      my ($heap,$widget,$event) = ($_[HEAP],$_[ARG1]->[0],$_[ARG1]->[1]);
      my $v_list = $heap->{vertex_list};
      my $vertex = [$event->{x},$event->{y}];
      $heap->{WIDGETS}->attract_vertex($heap,$vertex);

      if($v_list->empty()) {
        $heap->{WIDGETS}->create_backing($heap,$widget);
        $v_list->draw_loc($vertex,1);
      }
      else {
        my $start_select = $v_list->select(@$vertex);
        if(defined $start_select and $start_select >= 0) {
          $heap->{drag_vertex} = $start_select;
          $heap->{drag_mode} = $event->{state} & 0x01 ? 'stretch' : 'drag';
          $heap->{WIDGETS}->create_backing($heap,$widget);
          $heap->{WIDGETS}->copy_backing($heap);
          $v_list->draw($heap->{drag_vertex},$heap->{drag_mode} eq 'drag');
        }
        else {
          $heap->{drag_mode} = 'create'; # Create a new vertex
          $heap->{WIDGETS}->create_backing($heap,$widget);
          $heap->{WIDGETS}->copy_backing($heap);
          $heap->{WIDGETS}->draw_dashed_line(
            $widget,
            $heap->{pixmap},
            $v_list->location($heap->{last_selected}),
            $vertex
          );
          $v_list->draw_loc($vertex,1);
        }
      }
      $widget->draw();
    },
# }}}
# {{{ ev_motion_notify
    ev_motion_notify => sub {
      my ($heap,$widget,$event) = ($_[HEAP],$_[ARG1]->[0],$_[ARG1]->[1]);
      my $v_list = $heap->{vertex_list};
      my $vertex = [$event->{x},$event->{y}];
      $heap->{WIDGETS}->attract_vertex($heap,$vertex);

      if(defined $heap->{temp_pixmap}) {
        $heap->{WIDGETS}->copy_backing($heap);
        if($v_list->empty()) {
          $v_list->draw_loc($vertex,1);
        }
        elsif(!defined $heap->{drag_mode}) { # XXX JMG Hack to bypass warning
        }
        else {
          my $drag_mode = $heap->{drag_mode};
          if($drag_mode eq 'create') {
            $v_list->draw_loc($vertex,1);
            $v_list->draw_hull($widget,$heap->{pixmap});
            $heap->{WIDGETS}->draw_dashed_line(
              $widget,
              $heap->{pixmap},
              $v_list->location($heap->{last_selected}),
              $vertex
            );
          }
          elsif($drag_mode eq 'drag') {
            $v_list->move($heap->{drag_vertex},@$vertex);
            $v_list->draw_hull($widget,$heap->{pixmap});
            $heap->{WIDGETS}->draw_active_edges(
              $heap,$widget,$heap->{pixmap},$heap->{drag_vertex}
            );
            $v_list->draw($heap->{drag_vertex},1);
          }
          elsif($drag_mode eq 'stretch') {
            # Still nothing special...
          }
        }
        $widget->draw();
      }
    },
# }}}
# {{{ ev_button_release
    ev_button_release => sub {
      my ($heap,$widget,$event) = ($_[HEAP],$_[ARG1]->[0],$_[ARG1]->[1]);
      my $v_list = $heap->{vertex_list};
      my $vertex = [$event->{x},$event->{y}];
      $heap->{WIDGETS}->attract_vertex($heap,$vertex);

      if($v_list->empty()) {
        $v_list->add(@$vertex);
        $heap->{last_selected} = 0;
        $v_list->draw(0,1);
      }
      else {
        my $drag_mode = $heap->{drag_mode};
        if($drag_mode eq 'create') {
          $v_list->add(@$vertex);
          $v_list->draw_hull($widget,$heap->{pixmap});
          $heap->{WIDGETS}->draw_dashed_line(
            $widget,
            $heap->{pixmap},
            $v_list->location($heap->{last_selected}),
            $vertex
          );
          push @{$heap->{edge}},[$heap->{last_selected},$v_list->last()];
          $v_list->draw($v_list->last(),1);
          $heap->{last_selected} = $v_list->last();
        }
        elsif($drag_mode eq 'drag') {
          $heap->{WIDGETS}->copy_backing($heap);
          $v_list->draw($heap->{drag_vertex});
          $heap->{last_selected} = $heap->{drag_vertex};
          $v_list->draw_hull($widget,$heap->{pixmap});
          $heap->{WIDGETS}->draw_active_edges(
            $heap,$widget,$heap->{pixmap},$heap->{drag_vertex}
          );
          $v_list->draw($heap->{drag_vertex},1);
        }
        elsif($drag_mode eq 'stretch') {
          $v_list->add(@$vertex);
          $v_list->draw($v_list->last(),1);
        }
      }
      $heap->{WIDGETS}->backdrop($heap->{temp_pixmap},$widget);
      $heap->{WIDGETS}->draw_vertices($heap,$heap->{temp_pixmap});
      $heap->{WIDGETS}->draw_edges($heap,$widget,$heap->{temp_pixmap});
      $widget->draw();
      delete $heap->{drag_mode};
      delete $heap->{drag_vertex};
      delete $heap->{temp_pixmap};
    },
# }}}
# {{{ ev_pop
    ev_pop => sub {
      my $heap = $_[HEAP];
      $heap->{statusbar_count}--;
      $heap->{statusbar}->pop($heap->{statusbar_context});
    },
# }}}
# {{{ ev_push
    ev_push => sub {
      my $heap = $_[HEAP];
      $heap->{statusbar_count}++;
      $heap->{statusbar}->push(
        $heap->{statusbar_context},
        "Foo $heap->{statusbar_count}"
      );
    },
# }}}
# {{{ ev_exposure
    # Exposure called multiple times per expose event, apparently
    #
    ev_exposure => sub {
      my ($heap,$widget,$event) = ($_[HEAP],$_[ARG1]->[0],$_[ARG1]->[1]);

      $widget->window->draw_pixmap(
        $widget->style->fg_gc('normal'),
        $heap->{pixmap},
        $event->{area}[0],
        $event->{area}[1],
        $event->{area}[0],
        $event->{area}[1],
        $event->{area}[2],
        $event->{area}[3],
      );
    },
# }}}
# {{{ ev_realize
    # Realize is done only once...
    #
    ev_realize => sub {
      my ($heap,$widget,$event) = ($_[HEAP],$_[ARG1]->[0],$_[ARG1]->[1]);

      $heap->{pixmap} = Gtk::Gdk::Pixmap->new(
        $widget->window,
        $heap->{pane}{width},$heap->{pane}{height}
        -1
      );
      $heap->{gc}{black} = Gtk::Gdk::GC->new($widget->window);

      $heap->{WIDGETS}->backdrop($heap->{pixmap},$widget);
      $heap->{vertex_list}->pixmap($heap->{pixmap});
    },
# }}}
  }
);
# }}}

$poe_kernel->run();

exit 0;
