import 'package:daily_info/core/controllers/c_base.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:daily_info/features/task/data/repository/task_repository.dart';

class CTask extends CBase {
  final ITaskRepository _iTaskRepository;
  CTask(this._iTaskRepository);

  List<MTask> taskList = [];

  int currentPage = 1;
  final int limit = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> addTask(MTask payload) async {
    try {
      MTask mTask = await _iTaskRepository.addTask(payload);
      taskList.add(mTask);
      update();
      printer(taskList.length);
    } catch (e) {
      errorPrint(e);
    }
  }

  Future<void> updateTask(MTask payload) async {
    try {
      MTask mTask = await _iTaskRepository.updateTask(payload);
    } catch (e) {
      errorPrint(e);
    }
  }

  Future<void> deleteTask(MTask payload) async {
    try {
      await _iTaskRepository.deteteTask(payload);
      // clear from runtime storage
      taskList.removeWhere((mTask) => mTask.id == payload.id);
    } catch (e) {
      errorPrint(e);
    }
  }

  Future<void> fetchTask( MQuery query) async {
    try {

      List<MTask> taskList = await _iTaskRepository.fetchTask(query);
      this.taskList = taskList;
    } catch (e) {
      errorPrint(e);
    }
  }
}
