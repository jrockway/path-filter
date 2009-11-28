use MooseX::Declare;

class Path::Filter::Rule::VersionControl::Subversion
  with Path::Filter::Rule::Static {
      use Path::Filter::Types qw(Path);

      method get_instance(ClassName $class:){
          $class->new;
      }

      method as_regexp {
          return qr{[/\\].svn[/\\]};
      }

      method as_glob {
          return '.svn';
      }

      method evaluate(Path $path){
          $path = $path->dir if $path->isa('Path::Class::File');
          return 1 if grep { $_ eq '.svn' } @{$path->{dirs}};
          return;
      }
}
