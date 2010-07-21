package MyBlog::Controller::Blog;
use Moose;
use Digest::MD5  qw(md5_hex);
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

MyBlog::Controller::Blog - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub logout : Chained('/') : PathPart('logout') : Args(0) {
	my ( $self, $c ) = @_;
	
	$c->unset_authen_cookie();
	
	$c->response->redirect("/");
}

sub account : Chained('/') : PathPart('account') : Args(0) {
	my ( $self, $c ) = @_;
	
	if(!$self->_authenticate_user($c)) {
		# The user must login
		$c->response->redirect("/login");
	}
	
	if($c->req->param('title') && $c->req->param('body')) {
		
		my $title = $c->req->param('title');
		$title =~ s#\<script>(.*)\</script\>#$1#gi;
		my $body = $c->req->param('body');
		$body =~ s#\<script>(.*)\</script\>#$1#gi;
		my $new_blog = $c->model('MyBlog::Entry')->new_result({});
		$new_blog->title($title);
		$new_blog->body($body);
		$new_blog->insert;
		
		$c->stash->{info} = "Blog post created successfully.";
	}
	
	$c->stash(template => 'account.mason');
}

sub login : Chained('/') : PathPart('login') : Args(0) {
	my ( $self, $c ) = @_;
	
	if($self->_authenticate_user($c)) {
		# We have a valid cookie
		$c->response->redirect("/account");
	}
	
	if($c->req->param('username') && $c->req->param('password')) {
		# Looks like we have credentials for a login on our hands
		
		my $password_md5 = md5_hex( $c->req->param('password') );
		
		my $login_rs = $c->model('MyBlog::User')->search({	username => lc $c->req->param('username'), 
															password => $password_md5});
		
		if($login_rs->count == 1) {
			# Handle login cookie here
			my %expires;
			%expires = ( expires => '+1d' ) if $c->req->param('remember');

			$c->set_authen_cookie( value => { 	username => $c->req->param('username'),
												password => $password_md5, 
												user_id => $login_rs->next()->id},
                             		%expires);
                             		
            $c->response->redirect("/account");
			
		} else {
			$c->stash->{error} = "Username or password incorrect.";
		}
		
	} elsif($c->req->param('posted') == 1) {
		$c->stash->{error} = "Please enter a username and password.";
	}
	
	$c->stash(template => 'login.mason');
}

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


=head1 AUTHOR

Dean Pearce,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
