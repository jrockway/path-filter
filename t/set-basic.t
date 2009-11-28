use strict;
use warnings;
use Test::More;

use Path::Filter::Rule::Glob;
use Path::Filter::Rule::Set;
use Path::Filter::Rule::Backup;
use Path::Class;
use Path::Filter::Rule::EditorJunk::Emacs;
use Path::Filter::Rule::EditorJunk::Vim;

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

ok $set->evaluate(file('foo.doc'));
ok $set->evaluate(file('foo.txt'));
ok !$set->evaluate(file('foo.bar'));

ok !$set->evaluate(file('foo.txt', 'foo.bar'));
ok $set->evaluate(file('foo.txt', 'foo.txt'));

my $junk = Path::Filter::Rule::Set->new(
    rules => [Path::Filter::Rule::Backup::],
);

ok $junk, 'creating rule with classname is ok';

ok $junk->evaluate(file('foo.doc~'));
ok !$junk->evaluate(file('~', 'foo'));

my $editing_junk = Path::Filter::Rule::Set->new(
    rules => [ # testing coercion
        Path::Filter::Rule::Backup->new,
        'EditorJunk::Emacs',
        Path::Filter::Rule::EditorJunk::Vim::,
    ],
);

ok $editing_junk->evaluate(file('foo~'));
ok $editing_junk->evaluate(file('.#foo#'));
ok $editing_junk->evaluate(file('.foo.swp'));
ok !$editing_junk->evaluate(file('foo'));

done_testing;
