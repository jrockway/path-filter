use MooseX::Declare;

class Path::Filter::Rule::VersionControl::Git
  with Path::Filter::Rule::Static {
      use Path::Filter::Types qw(Path);

      method get_instance(ClassName $class:){
          $class->new;
      }

      method as_regexp {
          return qr{[/\\].git[/\\]};
      }

      method as_glob {
          return '.git';
      }

      method evaluate(Path $path){
          $path = $path->dir if $path->isa('Path::Class::File');

          return 1 if $path->is_absolute && grep { $_ eq '.git' } @{$path->{dirs}};
          return 1 if $path->is_relative && $path->{dirs}[0] eq '.git';
          return;
      }
}
