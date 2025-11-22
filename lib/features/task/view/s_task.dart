import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_task_section.dart';
import 'package:daily_info/core/widgets/w_timer_task_section.dart';
import 'package:daily_info/features/task/controller/c_task.dart';
import 'package:daily_info/features/task/data/datasource/task_datasource_impl.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/repository/task_repository_impl.dart';
import 'package:daily_info/features/task/view/s_see_all.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class STask extends StatefulWidget {
  STask({super.key});

  @override
  State<STask> createState() => _STaskState();
}

class _STaskState extends State<STask> {
  CTask cTask = PowerVault.put(CTask(TaskRepositoryImpl(TaskDataSourceImpl())));
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // load initial items
    cTask.fetchTask();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    PowerVault.delete<CTask>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task")),
      body: PowerBuilder<CTask>(
        builder: (cTask) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_sharp),
                  hintText: "Search Task Here",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tune_rounded),
                  ),
                ),
              ).pB(),
              Expanded(
                child: PowerBuilder<CTask>(
                  builder: (cTask) {
                    // final List<MTask> pendingList = [];
                    // final List<MTask> timeOutList = [];
                    // final List<MTask> completedList = [];

                    // cTask.taskList.map((mTask) {
                    //   if (isNotNull(mTask.finishedAt)) {
                    //     completedList.add(mTask);
                    //     return;
                    //   }
                    //   switch (DateTime.now().compareTo(
                    //     mTask.endAt ?? DateTime.now(),
                    //   )) {
                    //     case 1: // past
                    //       timeOutList.add(mTask);
                    //       return;
                    //     case -1: // future
                    //       pendingList.add(mTask);
                    //       return;
                    //     default: // now
                    //       timeOutList.add(mTask);
                    //       return;
                    //   }
                    // }).toList();

                    return CustomScrollView(
                      slivers: [
                        // todays task
                        SliverToBoxAdapter(child: gapY(20)),
                        WTimerTaskSection(
                          onTap: () async {
                            // clear current items
                            cTask.completedList.clear();
                            cTask.update();
                            await SSeeAll(taskState: TaskState.pending,).push();
                            // clear current items
                            cTask.completedList.clear();
                            cTask.update();
                            // load new items
                            await cTask.fetchSpacificItem(
                              payload: MQuery(taskState: TaskState.pending),
                            );
                          },
                          // items: pendingList,
                          title: 'Pending Task',
                          asSliver: true,
                        ),
                        WTaskSection(
                          onTap: () async {
                            // clear current items
                            cTask.completedList.clear();
                            cTask.update();
                            // navigate 
                            await SSeeAll(taskState: TaskState.timeOut).push();
                            // clear current items
                            cTask.completedList.clear();
                            cTask.update();
                            // load new items
                            await cTask.fetchSpacificItem(
                              payload: MQuery(taskState: TaskState.timeOut),
                            );
                          },
                          // items: timeOutList,
                          title: 'Time-Out Task',
                          taskState: TaskState.timeOut,
                          asSliver: true,
                        ),
                        WTaskSection(
                          onTap: () async {
                            // clear current items
                            cTask.completedList.clear();
                            cTask.update();
                            // navigate to new page
                            await SSeeAll(
                              taskState: TaskState.completed,
                            ).push();
                            // clear current items
                            cTask.completedList.clear();
                            cTask.update();
                            // load new items
                            await cTask.fetchSpacificItem(
                              payload: MQuery(taskState: TaskState.completed),
                            );
                          },
                          // items: completedList,
                          title: 'Completed Task',
                          taskState: TaskState.completed,
                          asSliver: true,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ).pAll();
        },
      ),
    );
  }
}
