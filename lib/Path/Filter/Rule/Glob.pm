use MooseX::Declare;

class Path::Filter::Rule::Glob
  with Path::Filter::Rule
  with Path::Filter::Rule::EvaluateViaRegex {
    has 'glob' => (
        is       => 'ro',
        reader   => 'as_glob',
        isa      => 'Str',
        required => 1,
    );

    method as_regexp {
        my $glob = $self->as_glob;
        $glob =~ s/[.]/[.]/g;
        $glob =~ s/\*/.*/g;
        return qr/^$glob$/;
    }
}
