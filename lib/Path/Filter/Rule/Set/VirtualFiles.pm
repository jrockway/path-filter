use MooseX::Declare;

class Path::Filter::Rule::Set::VirtualFiles with Path::Filter::Rule::Static {
    use Path::Filter::Types qw(Path);

    method get_instance(ClassName $class:) {
        $class->new;
    }

    method evaluate(Path $file) {
        if($file->isa('Path::Class::File')){
            return 1 if $file->{file} eq '.' || $file->{file} eq '..';
        }
        else {
            return 1 if $file->{dirs}[-1] eq '.' || $file->{dirs}[-1] eq '..';
        }
    }

    method to_glob { return "./\n../\n" }
    method to_regexp { return qr{(?:^|/)[.][.]?(?:/|$)} }
}
