use MooseX::Declare;

class Path::Filter::Rule::EditorJunk::Emacs
  with Path::Filter::Rule::Static {
      use Path::Filter::Types qw(Path);

      method get_instance(ClassName $class:){
          $class->new;
      }

      method as_regexp {
          return qr/[.]#.+#$/;
      }

      method as_glob {
          return '.#*#';
      }

      method evaluate(Path $path){
          return if $path->isa('Path::Class::Dir');

          my $re = $self->as_regexp;
          return 1 if $path->basename =~ qr/^$re$/;
          return;
      }
}
