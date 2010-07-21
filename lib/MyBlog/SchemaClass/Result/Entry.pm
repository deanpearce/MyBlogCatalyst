package MyBlog::SchemaClass::Result::Entry;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components();

=head1 NAME

MyBlog::SchemaClass::Result::Entry

=cut

__PACKAGE__->table("entries");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 body

  data_type: 'longtext'
  is_nullable: 0

=head2 posted

  data_type: 'timestamp'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "body",
  { data_type => "longtext", is_nullable => 0 },
  "posted",
  { data_type => "date", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-07-19 19:16:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8ZeDoG+ecKhsu3zP3H1jjA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
