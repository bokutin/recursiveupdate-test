package M2MTest::Schema2::Result::Dvd;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/IntrospectableM2M Core/);
__PACKAGE__->table('dvd');
__PACKAGE__->add_columns(
  'id' => {
    data_type => 'integer',
    is_auto_increment => 1
  },
  'name' => {
    data_type => 'varchar',
    size      => 100,
  },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('dvd_tags', 'M2MTest::Schema2::Result::DvdTag', 'dvd_id' );
__PACKAGE__->many_to_many('tags', 'dvd_tags' => 'tag');

1;
