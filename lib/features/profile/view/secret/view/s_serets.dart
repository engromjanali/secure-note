import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/constants/colors.dart';
import 'package:daily_info/core/constants/dimension_theme.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import 'package:daily_info/core/widgets/w_image_source_dialog.dart';
import 'package:daily_info/core/widgets/w_task_section.dart';
import 'package:daily_info/features/add/view/s_add.dart';
import 'package:daily_info/features/profile/view/secret/view/s_add_sencitive_note.dart';
import 'package:daily_info/features/profile/view/secret/widgets/w_select_note_type.dart';
import 'package:daily_info/features/task/controller/c_task.dart';
import 'package:daily_info/features/task/data/datasource/task_datasource_impl.dart';
import 'package:daily_info/features/task/data/repository/task_repository_impl.dart';
import 'package:daily_info/features/task/view/s_task.dart';
import 'package:daily_info/w_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';

class SSerets extends StatefulWidget {
  const SSerets({super.key});

  @override
  State<SSerets> createState() => _SSeretsState();
}

class _SSeretsState extends State<SSerets> with SingleTickerProviderStateMixin {
  CTask cTask = PowerVault.put(CTask(TaskRepositoryImpl(TaskDataSourceImpl())));
  TabController? _tabController;
  final List<String> tabs = const ['Fund Tnx List', 'Add Fund', 'Clear Fand'];
  final List<Icon> icons = const [
    Icon(Icons.list_alt),
    Icon(Icons.create),
    Icon(Icons.clear),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secret Note")),
      floatingActionButton: WFloatingActionButton(
        onTap: (index) {
          printer(index);
          if (index == 2) {
            SASNote().push();
          } else if (index == 1) {
            SAdd(onlyNote: true, isSecret: true).push();
          }
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [Secret(context), Secret(context)],
      ),
    );
  }
}

Widget Secret(BuildContext context) {
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
        child: CustomScrollView(
          slivers: [
            // todays task
            SliverToBoxAdapter(child: gapY(20)),
            WTaskSection(
              leadingColor: PColors.pendingColor,
              // items: [],
              title: 'Reguler Note',
              taskState: TaskState.note,
              asSliver: true,
            ),
            WTaskSection(
              leadingColor: PColors.completedColor,
              // items: [],
              title: 'Sencetive Note',
              taskState: TaskState.completed,
              asSliver: true,
            ),
          ],
        ),
      ),
    ],
  ).pAll();
}
