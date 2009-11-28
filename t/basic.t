use strict;
use warnings;
use Test::More;
use Test::Exception;

use Path::Filter;

my $filter = Path::Filter->new(
    rules => [qw/Backup EditorJunk/],
);

lives_ok {
    $filter->filter("/foo/bar.txt");
} 'filtering string lives';

ok $filter->filter('path/to/foo~'), 'backup filtered';
ok $filter->filter('foo~'), '"""';
ok $filter->filter('/foo/bar/.#thing#');
ok !$filter->filter('.#thing#/foo');
ok !$filter->filter('new.txt');

my $rooted = Path::Filter->new(
    rules => [qw/VersionControl::Git/],
    root  => '/foo/',
);

ok $rooted->filter('/foo/.git/config');
ok $rooted->filter('.git/config');
ok $rooted->filter('/foo/.git/refs/heads/');
ok !$rooted->filter('/foo/bar/.git/config');
ok !$rooted->filter('/foo/.gitignore');

done_testing;
