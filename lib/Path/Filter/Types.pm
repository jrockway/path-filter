package Path::Filter::Types;
use strict;
use warnings;

use Scalar::Util qw(blessed);
use Path::Class;
use MooseX::Types::Path::Class qw(File Dir);
use MooseX::Types::Moose qw(Str ArrayRef Any);
use MooseX::Types -declare => [qw/Rule _Rule Path Rules/];

role_type _Rule, { role => 'Path::Filter::Rule' };

subtype Rule, as _Rule, where { blessed $_ };

sub coerce_rule {
    my $from = shift || $_;

    my $class = "Path::Filter::Rule::$from";
    Class::MOP::load_class($class);

    return $class->does('Path::Filter::Rule::Static') ? $class->get_instance : $class->new ;
}

coerce Rule, from Str, via \&coerce_rule;

subtype Path, as File|Dir, where { defined $_ }; # Moose bug

coerce Path, from Str, via {
    if(-e $_){
        return -d $_ ? dir($_) : file($_); # on disk and is a dir, then dir
    }
    else {
        m{[/\\]$} ? dir($_) : file($_); # ends in \ or /, then dir
    }
};

subtype Rules, as ArrayRef[Rule];

coerce Rules, from ArrayRef[Any], via {
    my @rules = @{$_||[]};


    return [
        map {
            my $entry = $_;
            blessed $entry ? $entry :
            eval { Class::MOP::load_class($entry) && $entry->does('Path::Filter::Rule::Static') } ? $entry->get_instance :
              coerce_rule($entry);
        } @rules
    ];
};
