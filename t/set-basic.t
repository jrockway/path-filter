use strict;
use warnings;
use Test::More;

use Path::Filter::Rule::Glob;
use Path::Filter::Rule::Set;
use Path::Class;

my $txt = Path::Filter::Rule::Glob->new(
    glob => '*.txt',
);

my $doc = Path::Filter::Rule::Glob->new(
    glob => '*.doc',
);

my $set = Path::Filter::Rule::Set->new(
    rules => [$txt, $doc],
);

is $set->as_glob, "*.txt\n*.doc\n", 'got set as globs';
is $set->as_regexp, '(?-xism:(?:(?-xism:^.*[.]txt$)|(?-xism:^.*[.]doc$)))',
  'got set as single regexp';

ok $set->evaluate(Path::Class::file('foo.doc'));
ok $set->evaluate(Path::Class::file('foo.txt'));
ok !$set->evaluate(Path::Class::file('foo.bar'));

ok !$set->evaluate(Path::Class::file('foo.txt', 'foo.bar'));
ok $set->evaluate(Path::Class::file('foo.txt', 'foo.txt'));

done_testing;
