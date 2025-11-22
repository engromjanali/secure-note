import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/controllers/c_base.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
import 'package:daily_info/features/task/data/repository/task_repository.dart';

class CTask extends CBase {
  final ITaskRepository _iTaskRepository;
  CTask(this._iTaskRepository);

  // List<MTask> taskList = [];
  List<MTask> pendingList = [];
  List<MTask> timeOutList = [];
  List<MTask> completedList = [];

  final int limit = 10;
  int firstPage = 1;
  int lastPage = 1;
  bool hasMoreNext = true;
  bool get hasMorePrev => firstPage>1;
  bool isLoadingMore = false;
  // int get firstPage => currentPage - 5;

  void clearPaigenationChace() {
    hasMoreNext = true;
    isLoadingMore = false;
    lastPage = 1;
  }

  Future<void> addTask(MTask payload) async {
    try {
      MTask mTask = await _iTaskRepository.addTask(payload);
      pendingList.add(mTask);
      update();
      printer(pendingList.length);
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
      pendingList.removeWhere((mTask) => mTask.id == payload.id);
      timeOutList.removeWhere((mTask) => mTask.id == payload.id);
      completedList.removeWhere((mTask) => mTask.id == payload.id);
    } catch (e) {
      errorPrint(e);
    }
  }

  Future<void> fetchTask({MQuery? payload}) async {
    await fetchSpacificItem(payload: MQuery(taskState: TaskState.pending));
    clearPaigenationChace();
    await fetchSpacificItem(payload: MQuery(taskState: TaskState.timeOut));
    clearPaigenationChace();
    await fetchSpacificItem(payload: MQuery(taskState: TaskState.completed));
    clearPaigenationChace();
  }

  Future<List<MTask>?> fetchSpacificItem({MQuery? payload}) async {
    // try {
      TaskState taskState = (payload?.taskState ?? TaskState.pending);
      // printer("call 1");
      MQuery newPayload = MQuery(
        isLoadNext: payload?.isLoadNext ?? true,
        limit: payload?.limit ?? limit,
        filter:
            payload?.filter ??
            (taskState == TaskState.pending
                ? "finishedAt == null AND endAt > CURRENT_TIMESTAMP"
                : taskState == TaskState.timeOut
                ? "finishedAt == null AND endAt < CURRENT_TIMESTAMP"
                :
                  // taskState == TaskState.completed
                  // ?
                  "finishedAt not null"
            // : "note"
            ),
        pageNo: (payload?.isLoadNext ?? true) ? lastPage :firstPage,
        taskState: taskState,
      );

      // printer("call 2");
      if (isLoadingMore) {
        return null; //Already loading
      }
      // printer("call 3");
      // If loading next AND there are no more next pages, stop.
      if (newPayload.isLoadNext! && !hasMoreNext) {
        return null;
      }
      // printer("call 4");
      // If loading previous AND there are no more previous pages, stop.
      if (!newPayload.isLoadNext! && !hasMorePrev) {
        printer("load prev failed");
        return null;
      }
      // printer("call 5");
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
        }
        if (res.length < limit) hasMoreNext = false;
        ++lastPage;
      } else {
        printer("loaded previous");
        if (taskState == TaskState.pending) {
          pendingList.insertAll(0, res);
        } else if (taskState == TaskState.timeOut) {
          timeOutList.insertAll(0, res);
        } else if (taskState == TaskState.completed) {
          completedList.insertAll(0, res);
        }
        // hasMoreNext = true;
        --firstPage;
      }
      update();
      printer("call 6");
      return res;
    // } catch (e) {
      // errorPrint(e);
    // } finally {
      printer("call 7");
      isLoadingMore = false;
      update();
    // }
    return null;
  }
}
