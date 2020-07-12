use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib qw(t/lib);
use M2MTest;

for (2..2) {
    my $schema_class = "M2MTest::Schema$_" ;
    my $schema       = M2MTest->init_schema( schema_class => $schema_class );
    my $rs           = $schema->resultset('Dvd');
    my $dvd_tag_rs   = eval { $schema->resultset('Dvdtag') } || $schema->resultset('DvdTag');

    my $item;
    lives_and {
        $item = DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            updates   => {
                name => 'name',
                tags => [
                    { name => 'tag1_name' },
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many create";

    our $UPDATE = 1;
    my $dvd_pk = $schema_class =~ /Schema[12]/ ? 'dvd' : 'dvd_id';
    # lives_and {
    #     DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
    #         resultset => $dvd_tag_rs,
    #         updates   => {
    #             $dvd_pk => $item->id,
    #             tag     => $item->tags->first->id,
    #         },
    #     );
    #     is $rs->count, 1;
    #     is $rs->first->tags->count, 1;
    # } "$schema_class(@{[ $schema_class->abstract ]}) update (tags => id)";
    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $dvd_tag_rs,
            updates   => {
                $dvd_pk => $item->id,
                tag     => { id => $item->tags->first->id||die },
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) update (tag => hashref)";

    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            object    => $item,
            updates   => {
                name => 'name',
                tags => [
                    $item->tags->first->id,
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [ids])";
    
    local $main::DEBUG = sub { 1 };
    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            object    => $item,
            updates   => {
                name => 'name',
                tags => [
                    { id => $item->tags->first->id },
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [hashrefs])";

    local $main::DEBUG = sub { 1 };
    lives_and {
        DBIx::Class::ResultSet::RecursiveUpdate::Functions::recursive_update(
            resultset => $rs,
            object    => $item,
            updates   => {
                name => 'name',
                tags => [
                    { name => $item->tags->first->name },
                ],
            },
        );
        is $rs->count, 1;
        is $rs->first->tags->count, 1;
    } "$schema_class(@{[ $schema_class->abstract ]}) many_to_many update (tags => [hashrefs])";
}

done_testing();
