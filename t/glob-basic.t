use strict;
use warnings;
use Test::More;

use Path::Filter::Rule::Glob;
use Path::Class;

my $txt = Path::Filter::Rule::Glob->new(
    glob => '*.txt',
);

is $txt->as_glob, '*.txt';
is $txt->as_regexp, '(?-xism:^.*[.]txt$)', 'got regex';

ok $txt->evaluate(Path::Class::file('', 'foo', 'bar.txt'));
ok $txt->evaluate(Path::Class::dir('', 'foo', 'bar.txt'));
ok !$txt->evaluate(Path::Class::file('', 'foo', 'bar.txt', 'omg_a_file'));

done_testing;
