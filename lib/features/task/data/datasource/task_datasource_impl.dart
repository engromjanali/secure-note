import 'package:secure_note/core/data/local/db_local.dart';
import 'package:secure_note/features/task/data/datasource/task_datasource.dart';
import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';

class TaskDataSourceImpl extends ITaskDataSource {
  @override
  Future<MTask> addTask(MTask payload) async {
    return DBHelper.getInstance.addNote(payload);
  }

  @override
  Future<bool> deteteTask(int id) async {
    return DBHelper.getInstance.deleteNote(id: id);
  }

  @override
  Future<List<MTask>> fetchTask(MQuery payload) async {
    return DBHelper.getInstance.fetchTask(payload);
  }

  @override
  Future<MTask> updateTask(MTask payload) async {
    return DBHelper.getInstance.updateNote(payload: payload);
  }
}
