use strict;
use warnings;
use Test::More;

use File::Next::Filtered qw(files);
use Directory::Scratch;

my $tmp = Directory::Scratch->new;
$tmp->touch('.git/refs/heads/master');
$tmp->touch('.git/config');
$tmp->touch('Makefile.PL');
$tmp->touch('Makefile.PL~');
$tmp->touch('.gitignore');
$tmp->touch('lib/Foo/Bar.pm');
$tmp->touch('t/basic.t');
$tmp->touch('t/.#basic.t#');

{
    my $i = 0;
    my $baseline = File::Next::files("$tmp");
    while( $baseline->() ){ $i++ }
    is $i, 8, 'got all files with plain iterator';
}



{
    my $i = 0;
    my $iter = File::Next::Filtered::files({ filters => [qw/EditorJunk VersionControl::Git Backup/] }, "$tmp");
    while( $iter->() ){ $i++ }
    is $i, 4, 'with filter, only got relevant files';
}

done_testing;
