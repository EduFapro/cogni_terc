import '../database_constants.dart';
import '../module_instance/module_instance_constants.dart';
import '../task/task_constants.dart';

const ID_TASK_INSTANCE = "task_inst_id";
const ID_TASK_FK = ID_TASK;
const ID_MODULE_INSTANCE_FK = ID_MODULE_INSTANCE;
const TASK_INSTANCE_STATUS = "status";
const TASK_COMPLETING_TIME = "task_completing_time";

const SCRIPT_CREATE_TABLE_TASK_INSTANCES = '''
  CREATE TABLE $TABLE_TASK_INSTANCES
(
  $ID_TASK_INSTANCE INTEGER PRIMARY KEY AUTOINCREMENT,
  $ID_TASK_FK INTEGER NOT NULL,
  $ID_MODULE_INSTANCE_FK INTEGER NOT NULL,
  $TASK_INSTANCE_STATUS INT NOT NULL CHECK($TASK_INSTANCE_STATUS IN (0, 1)),
  $TASK_COMPLETING_TIME INTEGER,
  FOREIGN KEY ($ID_TASK_FK) REFERENCES $TABLE_TASKS($ID_TASK),
  FOREIGN KEY ($ID_MODULE_INSTANCE_FK) REFERENCES $TABLE_MODULE_INSTANCES($ID_MODULE_INSTANCE)
)

''';
