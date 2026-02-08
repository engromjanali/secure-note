import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/widgets/w_task_section.dart';
import 'package:secure_note/features/task/controller/c_task.dart';
import 'package:secure_note/features/task/data/datasource/task_datasource_impl.dart';
import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/repository/task_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class SNote extends StatefulWidget {
  const SNote({super.key});

  @override
  State<SNote> createState() => _SNoteState();
}

class _SNoteState extends State<SNote> {
  late CTask cTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PowerVault.delete<CTask>();
    cTask = PowerVault.put(CTask(TaskRepositoryImpl(TaskDataSourceImpl())));
  }

  @override
  void dispose() {
    // PowerVault.delete<CTask>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nots")),
      body: RefreshIndicator(
        onRefresh: () async {
          cTask.noteList.clear();
          cTask.clearPaigenationChace();
          await cTask.fetchSpacificItem(
            payload: MQuery(taskState: TaskState.note),
          );
        },
        color: context.textTheme?.titleMedium?.color,
        backgroundColor: context.fillColor,
        child: Column(children: [WTaskSection(taskState: TaskState.note)]),
      ).pAll(),
    );
  }
}
