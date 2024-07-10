const ID_TASK = "task_id";
const TITLE = "title";
const SNAKE_CASE_BRIEF_TRANSCRIPT = "snake_case_transcript";
const MODULE_ID = "module_id";
const MODE = "mode";
const POSITION = "position";
const IMAGE_PATH = "image_path";
const TIME_FOR_COMPLETION = "time_for_completion";
const MAY_REPEAT_PROMPT = "may_repeat_prompt";
const TEST_ONLY = "test_only";

const SCRIPT_CREATE_TABLE_TASKS = '''
 CREATE TABLE tasks
(
  $ID_TASK INTEGER PRIMARY KEY AUTOINCREMENT,
  $MODULE_ID INTEGER NOT NULL,
  $TITLE TEXT NOT NULL,
  $SNAKE_CASE_BRIEF_TRANSCRIPT TEXT,
  $MODE INT NOT NULL,
  $POSITION INT NOT NULL,
  $IMAGE_PATH TEXT,
  $MAY_REPEAT_PROMPT INT NOT NULL,
  $TEST_ONLY INT NOT NULL,
  $TIME_FOR_COMPLETION INTEGER NOT NULL,
  FOREIGN KEY (module_id) REFERENCES modules(module_id),
  CHECK(mode >= 0 AND mode <= 1),
  CHECK(may_repeat_prompt >= 0 AND may_repeat_prompt <= 1)
)
''';
