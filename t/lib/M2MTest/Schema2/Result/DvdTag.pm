package M2MTest::Schema2::Result::DvdTag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/IntrospectableM2M Core/);
__PACKAGE__->table("dvd_tag");
__PACKAGE__->add_columns(
    "dvd_id" => { data_type => 'integer' },
    "tag_id" => { data_type => 'integer' },
);
__PACKAGE__->set_primary_key("dvd_id", "tag_id");
__PACKAGE__->belongs_to("dvd", "M2MTest::Schema2::Result::Dvd", "dvd_id" );
__PACKAGE__->belongs_to("tag", "M2MTest::Schema2::Result::Tag", "tag_id" );

1;


