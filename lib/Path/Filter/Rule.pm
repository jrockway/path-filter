use MooseX::Declare;

role Path::Filter::Rule {
    requires 'evaluate'; # return 1 if the File or Dir should be filtered (i.e., is in the set)

    # these may die if the filter is too complex to be expressed in that format
    requires 'as_regexp';
    requires 'as_glob';
}
