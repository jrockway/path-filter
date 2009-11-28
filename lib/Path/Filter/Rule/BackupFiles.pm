use MooseX::Declare;

class Path::Filter::Rule::BackupFiles
  with Path::Filter::Rule::Static
  with Path::Filter::Rule::EvaluateViaRegex {

    method get_instance(ClassName $class:) {
        $class->new;
    }

    method as_regexp {
        return qr/~$/;
    }

    method as_glob {
        return '*~';
    }

}
