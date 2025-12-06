import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';

abstract class ITaskDataSource {
  Future<MTask> addTask(MTask payload);
  Future<MTask> updateTask(MTask payload);
  Future<bool> deteteTask(int id);
  Future<List<MTask>> fetchTask(MQuery payload);
}
