use MooseX::Declare;

class Path::Filter extends Path::Filter::Rule::Set {
    use Path::Filter::Types qw(Path);
    use MooseX::FileAttribute;

    has_directory 'root' => (
        required  => 0,
        predicate => 'has_root',
    );

    method filter(Path $file does coerce) {
        # canonicalize filename
        $file = -e $file ? $file->resolve : $file->cleanup;

        # make relative to root if has_root
        if($file->is_absolute){
            $file = $file->relative($self->root) if $self->has_root;
        }

        return $self->evaluate($file);
    }

    # method to_gitignore ... etc.
}
