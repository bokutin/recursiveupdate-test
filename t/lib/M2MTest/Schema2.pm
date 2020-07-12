package M2MTest::Schema2;

use base 'DBIx::Class::Schema';

sub abstract { "rel_name != fk naming" }

__PACKAGE__->load_namespaces( default_resultset_class => '+DBIx::Class::ResultSet::RecursiveUpdate' );

1;
