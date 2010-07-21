use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'MyBlog' }
BEGIN { use_ok 'MyBlog::Controller::Blog' }

ok( request('/blog')->is_success, 'Request should succeed' );
done_testing();
