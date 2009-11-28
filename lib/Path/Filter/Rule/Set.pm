use MooseX::Declare;

class Path::Filter::Rule::Set with Path::Filter::Rule {
    use MooseX::Types::Moose qw(ArrayRef);
    use Path::Filter::Types qw(Rule);

    has 'rules' => (
        traits     => ['Array'],
        is         => 'ro',
        isa        => ArrayRef[Rule],
        required   => 1,
        auto_deref => 1,
        default    => sub { [] },
        handles    => {
            add_rule => 'push',
        },
    );

    method evaluate($file) {
        my $filtered = 0;
        for my $filter ($self->rules) {
            $filter = $filter->get_instance
              if !blessed $filter && $filter->can('does') && $filter->does('Path::Filter::Rule::Static');
            $filtered ||= $filter->evaluate( $file );
            return 1 if $filtered; # short circuit
        }

        return $filtered;
    }

    method as_regexp {
        my $rx = '(?:'. join('|', map { $_->as_regexp } $self->rules). ')';
        return qr/$rx/;
    }

    method as_glob {
        return join '', map { $_->as_glob. "\n" } $self->rules;
    }
}