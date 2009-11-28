use MooseX::Declare;

role Path::Filter::Rule::EvaluateViaRegex {
    use Path::Filter::Types qw(Path);

    requires 'as_regexp';

    method evaluate(Path $file) {
        my $rx = $self->as_regexp;
        return $file->stringify =~ /$rx/;
    }
}
