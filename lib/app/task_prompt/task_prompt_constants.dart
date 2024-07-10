import '../database_constants.dart';
import '../task/task_constants.dart';

const ID_TASK_PROMPT = "prompt_id";
const ID_TASK_FK = ID_TASK;
const FILE_PATH = "file_path";
const TRANSCRIPTION = "transcription";

const SCRIPT_CREATE_TABLE_TASK_PROMPT = '''
  CREATE TABLE $TABLE_TASK_PROMPTS
  (
    $ID_TASK_PROMPT INTEGER PRIMARY KEY AUTOINCREMENT,
    $ID_TASK_FK INTEGER UNIQUE NOT NULL,
    $FILE_PATH TEXT NOT NULL,
    $TRANSCRIPTION TEXT,
    FOREIGN KEY ($ID_TASK_FK) REFERENCES $TABLE_TASKS($ID_TASK_FK)
  )
''';
