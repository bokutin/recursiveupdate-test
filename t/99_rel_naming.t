use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib qw(t/lib);
use M2MTest;

for (1..2) {
    my $schema_class = "M2MTest::Schema$_" ;
    my $schema       = M2MTest->init_schema( schema_class => $schema_class );
    my $dvd_rs       = $schema->resultset('Dvd');
    my $tag_rs       = $schema->resultset('Tag');
    my $dvd_tag_rs   = $schema->resultset('DvdTag');

    my $dvd     = $dvd_rs->create( { name => "dvd1" } );
    my $tag     = $tag_rs->create( { name => "tag1" } );
    my $dvd_tag = $dvd_tag_rs->create( { dvd => $dvd, tag => $tag } );
    # $dvd_tag_rs->create( { dvd_id => 2, tag_id => 1 } );
    # $dvd_tag_rs->create( { dvd_id => 1, tag_id => 2 } );

    #local $main::DEBUG = sub { 1 };
    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         object    => $dvd,
    #         resultset => $dvd_rs,
    #         updates   => {
    #             tags => [
    #                 $tag->id,
    #             ],
    #         },
    #         m2m_force_set_rel => 1,
    #     );
    # } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => [ids])";

    for my $m2m_force_set_rel (1,0) {
        lives_ok {
            DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
                object    => $dvd,
                resultset => $dvd_rs,
                updates   => {
                    tags => [
                        { id => $tag->id },
                    ],
                },
                m2m_force_set_rel => $m2m_force_set_rel,
            );
        } "$schema_class(@{[ $schema_class->abstract ]}) (tags => [ { id => ... } ]) m2m_force_set_rel => $m2m_force_set_rel";
    }


    #$dvd->tags->delete;
    # lives_and {
    #     #my @arg = (1);
    #     #$tag_rs->find_or_create( {@arg} );
    #     $dvd->set_tags(
    #         $tag->id,
    #     );
    # } "test";
    #
    # lives_and {
    #     $dvd->set_tags(
    #         { name => "tag1" },
    #     );
    # } "test";

    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         object    => $dvd,
    #         resultset => $dvd_rs,
    #         updates   => {
    #             tags => [
    #                 { name => "tag1" },
    #             ],
    #         },
    #         m2m_force_set_rel => 1,
    #     );
    # } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => [ { name => ... } ])";

    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         object    => $dvd,
    #         resultset => $dvd_rs,
    #         updates   => {
    #             tags => [
    #                 $tag->id,
    #             ],
    #         },
    #     );
    # } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => id)";

    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         object    => $tag,
    #         resultset => $tag_rs,
    #         updates   => {
    #             dvds => [
    #                 $dvd->id,
    #             ],
    #         },
    #     );
    # } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => id)";
}

done_testing();
