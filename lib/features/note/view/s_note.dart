import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_card.dart';
import 'package:daily_info/core/widgets/w_listtile.dart';
import 'package:daily_info/core/widgets/w_task_section.dart';
import 'package:daily_info/features/note/view/s_details.dart';
import 'package:daily_info/features/task/controller/c_task.dart';
import 'package:daily_info/features/task/data/datasource/task_datasource_impl.dart';
import 'package:daily_info/features/task/data/repository/task_repository_impl.dart';
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
    printer("build");
    return Scaffold(
      appBar: AppBar(title: Text("Nots")),
      body: WTaskSection(taskState: TaskState.note, isTask: false).pAll(),
    );
  }
}
