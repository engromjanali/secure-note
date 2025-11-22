
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';

abstract class ITaskDataSource {
  Future<MTask> addTask(MTask payload);
  Future<MTask> updateTask(MTask payload);
  Future<void> deteteTask(MTask payload);
  Future<List<MTask>> fetchTask(MQuery payload);
}
