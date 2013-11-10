#!/usr/bin/perl -w
#
# This is an example of a subclass of the generated application
#
# You can safely edit this file, any changes that you make will be preserved
# and this file will not be overwritten by the next run of Glade::PerlGenerate
#
#==============================================================================
#=== This is the 'Subapp1' class                              
#==============================================================================
package Subapp1;
require 5.000; use strict 'vars', 'refs', 'subs';
# UI class 'Subapp1' (version 0.01)
# 
# Copyright (c) Date Tue Sep 24 22:49:12 EDT 2002
# Author Jeff <jgoff@localhost.localdomain>
#
# Unspecified copying policy, please contact the author
# Jeff <jgoff@localhost.localdomain>
#
#==============================================================================
# This perl source file was automatically generated by 
# Glade::PerlGenerate version 0.60 - Fri May  3 03:56:25 BST 2002
# Copyright (c) Author Dermot Musgrove <dermot.musgrove@virgin.net>
#
# from Glade file /home/jgoff/Projects/NetDisplay/netdisplay.glade
# Sat Oct  5 16:06:16 EDT 2002
#==============================================================================

BEGIN {
    use vars qw( 
                 @ISA
                 %fields
                 $PACKAGE
                 $VERSION
                 $AUTHOR
                 $DATE
                 $permitted_fields
             );
    # Existing signal handler modules
    use src::NetDisplay;
    # We need the Gnome bindings as well
    use Gnome;
    # Uncomment the line below to enable gettext checking
#    use Glade::PerlSource;
    # Tell interpreter who we are inheriting from
    @ISA     = qw( app1 );
    # Uncomment the line below to enable gettext checking
#    @ISA      = qw( app1 Glade::PerlSource );
    $PACKAGE = 'SubNetDisplay';
    $VERSION = '0.01';
    $AUTHOR  = 'Jeff <jgoff@localhost.localdomain>';
    $DATE    = 'Tue Sep 24 22:49:12 EDT 2002';
    $permitted_fields = '_permitted_fields';             
    # Inherit the AUTOLOAD dynamic methods from app1
    *AUTOLOAD = \&app1::AUTOLOAD;
} # End of sub BEGIN

%fields = (
# Insert any extra data access methods that you want to add to 
#   our inherited super-constructor (or overload)
    USERDATA    => undef,
    VERSION     => '0.10',
);

sub DESTROY {
    # This sub will be called on object destruction
} # End of sub DESTROY

#==============================================================================
#=== Below are the overloaded class constructors
#==============================================================================
sub new {
    my $that  = shift;
    # Allow indirect constructor so that we can call eg. 
    #   $window1 = Frame->new; $window2 = $window1->new;
    my $class = ref($that) || $that;

    # Call our super-class constructor to get an object and reconsecrate it
    my $self = bless $that->SUPER::new(), $class;

    # Add our own data access methods to the inherited constructor
    my($element);
    foreach $element (keys %fields) {
        $self->{$permitted_fields}->{$element} = $fields{$element};
    }
    @{$self}{keys %fields} = values %fields;
    return $self;
} # End of sub new

sub app_run {
    my ($class, %params) = @_;
    Gnome->init('NetDisplay', '0.01');
    # Uncomment the line below to enable gettext checking
#    $class->check_gettext_strings;
    my $window = $class->new;
    # Insert your subclass user data key/value pairs 
    $window->USERDATA({
#        'Key1'   => 'Value1',
#        'Key2'   => 'Value2',
#        'Key3'   => 'Value3',
    });
    $window->TOPLEVEL->show;
#    my $window2 = $window->new;
#    $window2->TOPLEVEL->show;
    Gtk->main;
    # Uncomment the line below to enable gettext checking
#    $window->write_gettext_strings("__", '/home/jgoff/Projects/NetDisplay/src/NetDisplay.pot');
    $window->TOPLEVEL->destroy;

    return $window;
} # End of sub run
#===============================================================================
#=== Below are (overloaded) default signal handlers for 'app1' class 
#===============================================================================
sub about_Form {
    my ($class) = @_;
    my $gtkversion = 
        Gtk->major_version.".".
        Gtk->minor_version.".".
        Gtk->micro_version;
    my $name = $0;
    #
    # Create a Gnome::About '$ab'
    my $ab = new Gnome::About(
        $PACKAGE, 
        $VERSION, 
        _("Copyright")." $DATE", 
        $AUTHOR, 
        _('No description')."\n".
        "Gtk ".     _("version").": $gtkversion\n".
        "Gtk-Perl "._("version").": $Gtk::VERSION\n".
        `gnome-config --version`."\n".
        _("run from file").": $name\n \n".
        '# Unspecified copying policy, please contact the author
#', 
        "$Glade::PerlRun::pixmaps_directory/Logo.xpm", 
    );
    $ab->set_title(_("About")." SubNetDisplay" );
    $ab->position('mouse' );
    $ab->set_policy(1, 1, 0 );
    $ab->set_modal(1 );
    $ab->show;
} # End of sub about_Form

sub destroy_Form {
    my ($class, $data, $object, $instance) = @_;
    Gtk->main_quit; 
} # End of sub destroy_Form

sub toplevel_hide    { shift->get_toplevel->hide    }
sub toplevel_close   { shift->get_toplevel->close   }
sub toplevel_destroy { shift->get_toplevel->destroy }

#==============================================================================
#=== Below are (overloaded) signal handlers for 'app1' class 
#==============================================================================
sub on_about1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_about1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_about1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_about1_activate(@_);

} # End of sub on_about1_activate

sub on_clear1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_clear1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_clear1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_clear1_activate(@_);

} # End of sub on_clear1_activate

sub on_copy1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_copy1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_copy1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_copy1_activate(@_);

} # End of sub on_copy1_activate

sub on_cut1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_cut1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_cut1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_cut1_activate(@_);

} # End of sub on_cut1_activate

sub on_exit1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_exit1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_exit1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_exit1_activate(@_);

} # End of sub on_exit1_activate

sub on_new_file1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_new_file1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_new_file1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_new_file1_activate(@_);

} # End of sub on_new_file1_activate

sub on_open1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_open1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_open1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_open1_activate(@_);

} # End of sub on_open1_activate

sub on_paste1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_paste1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_paste1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_paste1_activate(@_);

} # End of sub on_paste1_activate

sub on_preferences1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_preferences1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_preferences1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_preferences1_activate(@_);

} # End of sub on_preferences1_activate

sub on_properties1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_properties1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_properties1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_properties1_activate(@_);

} # End of sub on_properties1_activate

sub on_save1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_save1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_save1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_save1_activate(@_);

} # End of sub on_save1_activate

sub on_save_as1_activate {
    my ($class, $data, $object, $instance, $event) = @_;
    my $me = __PACKAGE__."->on_save_as1_activate";
    # Get ref to hash of all widgets on our form
    my $form = $__PACKAGE__::all_forms->{$instance};

    # REPLACE the lines below with the actions to be taken when __PACKAGE__."->on_save_as1_activate." is called
#    __PACKAGE__->show_skeleton_message($me, \@_, __PACKAGE__, "$Glade::PerlRun::pixmaps_directory/Logo.xpm");
    shift->SUPER::on_save_as1_activate(@_);

} # End of sub on_save_as1_activate











1;

__END__

#===============================================================================
#==== Documentation
#===============================================================================
=pod

=head1 NAME

SubNetDisplay - version 0.01 Tue Sep 24 22:49:12 EDT 2002

No description

=head1 SYNOPSIS

 use SubNetDisplay;

 To construct the window object and show it call
 
 Gtk->init;
 my $window = Subapp1->new;
 $window->TOPLEVEL->show;
 Gtk->main;
 
 OR use the shorthand for the above calls
 
 Subapp1->app_run;

=head1 DESCRIPTION

Unfortunately, the author has not yet written any documentation :-(

=head1 AUTHOR

Jeff <jgoff@localhost.localdomain>

=cut
