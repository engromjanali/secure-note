import 'package:secure_note/features/task/data/datasource/task_datasource.dart';
import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:secure_note/features/task/data/repository/task_repository.dart';

class TaskRepositoryImpl extends ITaskRepository {
  final ITaskDataSource _iTaskDataSource;
  TaskRepositoryImpl(this._iTaskDataSource);

  @override
  Future<MTask> addTask(MTask payload) async {
    return _iTaskDataSource.addTask(payload);
  }

  @override
  Future<bool> deteteTask(int id) async {
    return _iTaskDataSource.deteteTask(id);
  }

  @override
  Future<List<MTask>> fetchTask(MQuery payload) async {
    return _iTaskDataSource.fetchTask(payload);
  }

  @override
  Future<MTask> updateTask(MTask payload) async {
    return _iTaskDataSource.updateTask(payload);
  }
}
