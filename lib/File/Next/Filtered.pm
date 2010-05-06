package File::Next::Filtered;

use strict;
use warnings;

use File::Next;
use Path::Filter;

use Sub::Exporter -setup => {
    exports => ['files'],
};

sub files {
    my ($first, @rest) = @_;

    my %args;
    my @files;
    if(ref $first){
        %args = %$first;
        @files = @rest;
    }
    else {
        @files = ($first, @rest);
    }

    my $filter = delete $args{filter} || Path::Filter->new(
        rules => (delete $args{filters} || [qw/Backup VersionControl EditorJunk/]),
        (@files == 1) ? ( root => $files[0] ) : (),
    );

    my $iter = File::Next::files(\%args, @files);

    no warnings 'recursion';
    my $self; $self = sub {
        my $next = $iter->();
        return unless defined $next;
        $next = Path::Class::file($next);
        return $self->() if($filter->filter($next));
        return $next;
    };

    return $self;
}

1;
