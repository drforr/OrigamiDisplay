package Widgets::Menubar;

use warnings;
use strict;

use vars '@ISA';
@ISA=qw(Gtk::Menu);

# {{{ _submenu
sub _submenu {
  my ($session,$items) = @_;

  my $widget = Gtk::Menu->new();
  for(my $j=0;$j<@$items;$j+=2) {
    my $name    = $items->[$j];
    my $handler = $items->[$j+1] || undef;

    my $menuItem = Gtk::MenuItem->new($name);
    $menuItem->signal_connect('activate', $session->postback($handler,$name))
      if defined $handler;
    $widget->append($menuItem);
    $menuItem->show();
  }
  $widget->show();
  $widget;
}
# }}}
# {{{ new
sub new {
  my $proto   = shift;
  my $session = shift;
  my $heap    = shift;
  my $menus   = shift;
  my $class = ref $proto || $proto;

  my $widget = Gtk::MenuBar->new();
  for(my $i=0;$i<@$menus;$i+=2) {
    my $name  = $menus->[$i];
    my $items = $menus->[$i+1];
    my $menu  = Gtk::MenuItem->new($name);

    if(defined $items) {
      my $submenu = _submenu($session,$items);
      $menu->set_submenu($submenu);
    }
    $menu->show();
    $widget->append($menu);
  }
  $widget->show();
  $heap->{box}->pack_start( $widget, 0, 0, 2 );

  bless $widget,$class;
}
# }}}

1;

__END__

=pod

=head1 NAME

Widgets::Menubar - Container for scrollable text

=head1 SYNOPSIS

 use Widgets::Menubar;

=head1 DESCRIPTION

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
