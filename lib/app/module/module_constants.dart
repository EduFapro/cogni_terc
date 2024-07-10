
import '../database_constants.dart';

const ID_MODULE = "module_id";
const TITLE = "title";

const SCRIPT_CREATE_TABLE_MODULES = '''
  CREATE TABLE $TABLE_MODULES
  (
    $ID_MODULE INTEGER PRIMARY KEY AUTOINCREMENT,
    $TITLE TEXT NOT NULL
  )
''';
