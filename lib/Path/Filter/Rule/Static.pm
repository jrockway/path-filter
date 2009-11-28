use MooseX::Declare;

role Path::Filter::Rule::Static with Path::Filter::Rule {
    requires 'get_instance';
}

1;
