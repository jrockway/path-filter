use MooseX::Declare;

class Path::Filter::Rule::VersionControl
  extends Path::Filter::Rule::Set
  with Path::Filter::Rule::Static {
      use Path::Filter::Rule::VersionControl::Subversion;
      use Path::Filter::Rule::VersionControl::Git;

      method get_instance(ClassName $class:) {
          return $class->new(
              rules => [
                  Path::Filter::Rule::VersionControl::Git::,
                  Path::Filter::Rule::VersionControl::Subversion::,
              ],
          );
      }

}
