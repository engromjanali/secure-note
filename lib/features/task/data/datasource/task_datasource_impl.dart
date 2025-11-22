import 'package:daily_info/core/data/local/db_local.dart';
import 'package:daily_info/features/task/data/datasource/task_datasource.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';

class TaskDataSourceImpl extends ITaskDataSource {
  @override
  Future<MTask> addTask(MTask payload) async {
    // return DBHelper.getInstance.addNote(payload);
    return payload;
  }

  @override
  Future<void> deteteTask(MTask payload) async {
    // return DBHelper.getInstance.deleteNote(id: payload.id);
    // TODO: implement deteteTask
    throw UnimplementedError();
  }

  @override
  Future<List<MTask>> fetchTask(MQuery payload) async {
    return DBHelper.getInstance.fetchTask(payload);
  }

  @override
  Future<MTask> updateTask(MTask payload) async {
    // return DBHelper.getInstance.updateNote(payload);
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
