#!/usr/local/bin/perl

use 5.010;
use strict;
use warnings;
use lib "lib";
use Cwd;

local $ENV{HFH_TEST} = 1;

my @lib_proj  = (
    "DBIx-Class-ResultSet-RecursiveUpdate-0.34",
    "DBIx-Class-ResultSet-RecursiveUpdate-0.40",
    "DBIx-Class-ResultSet-RecursiveUpdate-0.41",
    #"dbix-class-resultset-recursiveupdate-0.34",
    #"dbix-class-resultset-recursiveupdate-0.41",
    #"dbix-class-resultset-recursiveupdate",
    #"/",
);
my @test_proj = (
    #[ "HTML-FormHandler-Model-DBIC-0.29", "t/fif.t" ],
    #[ "DBIx-Class-ResultSet-RecursiveUpdate-0.41", "t" ],
    #[ "dbix-class-resultset-recursiveupdate-0.41", "t" ],
    #[ "html-formhandler-model-dbic", "t" ],
    #[ "html-formhandler-model-dbic", "t/00create_db.t t/db_has_many.t" ],
    #[ "hfh-test", "t" ],
    #[ "hfh-test", "t/99_m2m_form_compat.t" ],
    #[ "hfh-test", "t/99_m2m_pass.t" ],
    #[ "hfh-test", "t/99_simple.t" ],
    #"hfh-test",
    #[ getcwd, "t/99_small_relname.t" ],
    [ getcwd, "t/99_rel_naming.t" ],
);

for (@test_proj) {
    for my $lib_proj (@lib_proj) {
        my ($test_dir, $test_file) = @$_;

        say "--> test[$test_dir $test_file] lib[$lib_proj]";
        my $cmd = "cd $test_dir; prove -I $lib_proj/lib -v $test_file";
        say "$cmd";
        system($cmd);
        die if $?&255;
        say "";
    }
}
