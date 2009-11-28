use strict;
use warnings;
use Test::More;

use Path::Class;

use Path::Filter::Rule::EditorJunk;

my $ej = Path::Filter::Rule::EditorJunk->get_instance;

ok $ej->evaluate(file('.foo.bar.baz.swp'));
ok $ej->evaluate(file('.#foo.bar.baz#'));
ok !$ej->evaluate(dir('.foo.bar.baz.swp'));
ok !$ej->evaluate(dir('.#foo.bar.baz#'));

ok $ej->evaluate(file('','foo','bar','.baz.swp'));
ok !$ej->evaluate(file('','foo','bar','.baz.swp','normal file'));

done_testing;
