use strict;
use warnings;
use Test::More;

use Path::Class;

use Path::Filter::Rule::EditorJunk;
use Path::Filter::Rule::VersionControl::Git;

my $ej = Path::Filter::Rule::EditorJunk->get_instance;

ok $ej->evaluate(file('.foo.bar.baz.swp'));
ok $ej->evaluate(file('.#foo.bar.baz#'));
ok !$ej->evaluate(dir('.foo.bar.baz.swp'));
ok !$ej->evaluate(dir('.#foo.bar.baz#'));

ok $ej->evaluate(file('','foo','bar','.baz.swp'));
ok !$ej->evaluate(file('','foo','bar','.baz.swp','normal file'));

my $git = Path::Filter::Rule::VersionControl::Git->get_instance;
ok $git->evaluate(file('', 'foo', '.git', 'config'));
ok !$git->evaluate(file('foo', '.git', 'config'));
ok $git->evaluate(file('.git', 'config'));

ok $git->evaluate(dir('', 'foo', '.git', 'refs', 'heads'));
ok !$git->evaluate(dir('foo', '.git', 'refs', 'heads'));
ok $git->evaluate(dir('.git', 'refs', 'heads'));

ok !$git->evaluate(file('.gitignore'));
ok !$git->evaluate(file('', 'foo', '.gitignore'));
ok !$git->evaluate(file('', '.gitignore'));

done_testing;
