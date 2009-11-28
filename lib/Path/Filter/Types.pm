package Path::Filter::Types;
use strict;
use warnings;

use Path::Class;
use MooseX::Types::Path::Class qw(File Dir);
use MooseX::Types::Moose qw(Str);
use MooseX::Types -declare => [qw/Rule Path/];

role_type Rule, { role => 'Path::Filter::Rule' };

coerce Rule, from Str, via {
    my $f = $_;
    my $class = "Path::Filter::Rule::$f";
    Class::MOP::load_class($class);

    return $class->new;
};

subtype Path, as File|Dir, where { defined $_ }; # Moose bug

coerce Path, from Str, via {
    if(-e $_){
        return -d $_ ? dir($_) : file($_); # on disk and is a dir, then dir
    }
    else {
        m{[/\\]$} ? dir($_) : file($_); # ends in \ or /, then dir
    }
};
