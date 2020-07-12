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

    my $dvd = $dvd_rs->create( { name => "dvd1" } );
    my $tag = $tag_rs->create( { name => "tag1" } );
    $dvd_tag_rs->create( { dvd => $dvd, tag => $tag } );
    # $dvd_tag_rs->create( { dvd_id => 2, tag_id => 1 } );
    # $dvd_tag_rs->create( { dvd_id => 1, tag_id => 2 } );

    #local $main::DEBUG = sub { 1 };
    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            object    => $dvd,
            resultset => $dvd_rs,
            updates   => {
                tags => [
                    $tag->id,
                ],
            },
        );
    } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => id)";

    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            object    => $tag,
            resultset => $tag_rs,
            updates   => {
                dvds => [
                    $dvd->id,
                ],
            },
        );
    } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => id)";

    # my $item;
    # lives_and {
    #     $item = DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         resultset => $rs,
    #         updates   => {
    #             name => 'name',
    #             tags => [
    #                 { name => 'tag1_name' },
    #             ],
    #         },
    #     );
    #     is $rs->count, 1;
    #     is $rs->first->tags->count, 1;
    # } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many create";
    #
    # our $UPDATE = 1;
    # my $dvd_pk = $schema_class =~ /Schema[12]/ ? 'dvd' : 'dvd_id';
    # # lives_and {
    # #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    # #         resultset => $dvd_tag_rs,
    # #         updates   => {
    # #             $dvd_pk => $item->id,
    # #             tag     => $item->tags->first->id,
    # #         },
    # #     );
    # #     is $rs->count, 1;
    # #     is $rs->first->tags->count, 1;
    # # } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => id)";
    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         resultset => $dvd_tag_rs,
    #         updates   => {
    #             $dvd_pk => $item->id,
    #             tag     => { id => $item->tags->first->id||die },
    #         },
    #     );
    #     is $rs->count, 1;
    #     is $rs->first->tags->count, 1;
    # } "$schema_class(@{[ $schema_class->abstract ]}) update (tag => hashref)";
    #
    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         resultset => $rs,
    #         object    => $item,
    #         updates   => {
    #             name => 'name',
    #             tags => [
    #                 $item->tags->first->id,
    #             ],
    #         },
    #     );
    #     is $rs->count, 1;
    #     is $rs->first->tags->count, 1;
    # } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [ids])";
    #
    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         resultset => $rs,
    #         object    => $item,
    #         updates   => {
    #             name => 'name',
    #             tags => [
    #                 { id => $item->tags->first->id },
    #             ],
    #         },
    #     );
    #     is $rs->count, 1;
    #     is $rs->first->tags->count, 1;
    # } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [hashrefs])";
    #
    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         resultset => $rs,
    #         object    => $item,
    #         updates   => {
    #             name => 'name',
    #             tags => [
    #                 { name => $item->tags->first->name },
    #             ],
    #         },
    #     );
    #     is $rs->count, 1;
    #     is $rs->first->tags->count, 1;
    # } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [hashrefs])";
}

ok 1;

done_testing();
