use MooseX::Declare;

class Path::Filter::Rule::EditorJunk
  extends Path::Filter::Rule::Set
  with Path::Filter::Rule::Static {
      use Path::Filter::Rule::EditorJunk::Emacs;
      use Path::Filter::Rule::EditorJunk::Vim;

      method get_instance(ClassName $class:) {
          return $class->new(
              rules => [
                  Path::Filter::Rule::EditorJunk::Emacs::,
                  Path::Filter::Rule::EditorJunk::Vim::,
              ],
          );
      }

}
