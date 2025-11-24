import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';

abstract class ITaskRepository {
  Future<MTask> addTask(MTask payload);
  Future<MTask> updateTask(MTask payload);
  Future<bool> deteteTask(int id);
  Future<List<MTask>> fetchTask(MQuery payload);
}
