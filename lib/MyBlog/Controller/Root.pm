package MyBlog::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

MyBlog::Controller::Root - Root Controller for MyBlog

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Chained('/') : PathPart('') {
    my ( $self, $c, $page ) = @_;
    
    $self->_authenticate_user($c);
    
    my $count = $c->model('MyBlog::Entry')->search()->count();
    
    $c->stash->{pages} = int($count / 10) + 1;
    
    if(defined $page && $page =~ /\d+/) {
		# TODO Handle action here
    } else {
    	$page = 1;
    }
    
    $c->stash->{on_page} = $page;
	my @blog_entries = $c->model('MyBlog::Entry')->search({}, {	rows => 5,
          														page => $page,
																order_by => { -desc => [qw/posted/] }});
	$c->stash->{latest_entries} = \@blog_entries;
	$c->stash(template => 'home.mason');
}

=head2 default

Standard 404 error page

=cut

#sub default :Path {
#    my ( $self, $c ) = @_;
#    $c->response->body( 'Page not found' );
#    $c->response->status(404);
#}

sub _authenticate_user {
	my ($self, $c) = @_;
	
	my $cookie = $c->authen_cookie_value();
	
	my $login_rs = $c->model('MyBlog::User')
		->search({	username => lc $cookie->{username}, 
					password => $cookie->{password} });
		
	if($login_rs->count == 1) {
		$c->stash->{user_id} = $cookie->{user_id};
		$c->stash->{username} = $cookie->{username};
		return 1;
	} else {
		return 0;
	}	
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Dean Pearce,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
