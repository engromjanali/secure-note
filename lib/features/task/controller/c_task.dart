import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/controllers/c_base.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:secure_note/features/task/data/repository/task_repository.dart';

class CTask extends CBase {
  final ITaskRepository _iTaskRepository;
  CTask(this._iTaskRepository);

  // List<MTask> taskList = [];
  List<MTask> pendingList = [];
  List<MTask> timeOutList = [];
  List<MTask> completedList = [];
  List<MTask> noteList = [];

  final int limit = PDefaultValues.limit;
  int firstPage = 1;
  int lastPage = 1;
  bool hasMoreNext = true;
  bool get hasMorePrev => firstPage > 1;
  bool isLoadingMore = false;
  // int get firstPage => currentPage - 5;

  void clearPaigenationChace() {
    hasMoreNext = true;
    isLoadingMore = false;
    lastPage = 1;
  }

  Future<void> addTask(MTask payload) async {
    try {
      isLoadingMore = true;
      update();
      MTask mTask = await _iTaskRepository.addTask(payload);
      await Future.delayed(Duration(seconds: 2));
      printer(pendingList.length);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> updateTask(MTask payload) async {
    try {
      isLoadingMore = true;
      update();
      MTask mTask = await _iTaskRepository.updateTask(payload);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> deleteTask(int id) async {
    printer("deleteWhere id = $id");
    try {
      isLoadingMore = true;
      update();
      await _iTaskRepository.deteteTask(id);
      // clear from runtime storage
      pendingList.removeWhere((mTask) => mTask.id == id);
      timeOutList.removeWhere((mTask) => mTask.id == id);
      completedList.removeWhere((mTask) => mTask.id == id);
      noteList.removeWhere((mTask) => mTask.id == id);
    } catch (e) {
      errorPrint(e);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  Future<void> fetchTask({MQuery? payload}) async {
    pendingList.clear();
    timeOutList.clear();
    completedList.clear();
    await fetchSpacificItem(payload: MQuery(taskState: TaskState.pending));
    clearPaigenationChace();
    await fetchSpacificItem(payload: MQuery(taskState: TaskState.timeOut));
    clearPaigenationChace();
    await fetchSpacificItem(payload: MQuery(taskState: TaskState.completed));
    clearPaigenationChace();
  }

  Future<List<MTask>?> fetchSpacificItem({MQuery? payload}) async {
    print("called fetched spacfic item payload");
    try {
      TaskState taskState = (payload?.taskState ?? TaskState.pending);
      // printer("call 1");
      MQuery newPayload = MQuery(
        isLoadNext: payload?.isLoadNext ?? true,
        limit: payload?.limit ?? limit,
        where:
            payload?.where ??
            (taskState == TaskState.pending
                ?
                  // "finishedAt IS NULL AND
                  "finishedAt IS NULL AND endAt IS NOT NULL AND endAt > ?"
                : taskState == TaskState.timeOut
                ? "finishedAt IS NULL AND endAt IS NOT NULL AND endAt < ?"
                : taskState == TaskState.completed
                ? "finishedAt IS NOT NULL"
                : "finishedAt IS NULL AND endAt IS NULL"),
        args: [
          if (taskState == TaskState.pending)
            DateTime.timestamp().toIso8601String(),
          if (taskState == TaskState.timeOut)
            DateTime.timestamp().toIso8601String(),
        ],
        pageNo: (payload?.isLoadNext ?? true) ? lastPage : firstPage,
        taskState: taskState,
      );

      printer("call 2");
      if (isLoadingMore) {
        return null; //Already loading
      }
      printer("call 3");
      // If loading next AND there are no more next pages, stop.
      if (newPayload.isLoadNext! && !hasMoreNext) {
        return null;
      }
      printer("call 4");
      // If loading previous AND there are no more previous pages, stop.
      if (!newPayload.isLoadNext! && !hasMorePrev) {
        printer("load prev failed");
        return null;
      }
      printer("call 5");
      isLoadingMore = true;
      update();
      List<MTask> res = await _iTaskRepository.fetchTask(newPayload);
      if (newPayload.isLoadNext!) {
        if (taskState == TaskState.pending) {
          pendingList.addAll(res);
        } else if (taskState == TaskState.timeOut) {
          timeOutList.addAll(res);
        } else if (taskState == TaskState.completed) {
          completedList.addAll(res);
        } else {
          noteList.addAll(res);
        }
        if (res.length < limit) {
          hasMoreNext = false;
          printer("has more has been false");
        }
        ++lastPage;
      } else {
        printer("loaded previous");
        if (taskState == TaskState.pending) {
          pendingList.insertAll(0, res);
        } else if (taskState == TaskState.timeOut) {
          timeOutList.insertAll(0, res);
        } else if (taskState == TaskState.completed) {
          completedList.insertAll(0, res);
        } else {
          noteList.insertAll(0, res);
        }
        // hasMoreNext = true;
        --firstPage;
      }
      update();
      printer("call 6");
      return res;
    } catch (e) {
      errorPrint(e);
      showSnackBar(e.toString());
    } finally {
      printer("call 7");
      isLoadingMore = false;
      update();
    }
    return null;
  }
}
