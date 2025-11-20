import 'package:daily_info/features/task/data/datasource/demo_data.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:daily_info/features/task/data/repository/task_repository.dart';

class TaskRepositoryImpl extends ITaskRepository {
  @override
  Future<MTask> addTask(MTask payload) async {
    taskList.add(payload);
    return payload;
  }

  @override
  Future<void> deteteTask(MTask payload) async {
    // TODO: implement deteteTask
    throw UnimplementedError();
  }

  @override
  Future<List<MTask>> fetchTask(MQuery payload) async {
    // TODO: implement fetchTask
    throw UnimplementedError();
  }

  @override
  Future<MTask> updateTask(MTask payload) async {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
