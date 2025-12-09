import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/note/view/s_note.dart';
import 'package:secure_note/features/profile/view/s_profile.dart';
import 'package:secure_note/features/stopwatch/view/s_stopwatch.dart';
import 'package:secure_note/features/task/view/s_task.dart';
import 'package:secure_note/gen/assets.gen.dart';
import 'm_nav_bar_item.dart';

List<MNavBarItem> homeNevItem = [
  MNavBarItem(
    title: "Task",
    unSelectedIcon: Assets.icons.taskChecklist,
    icon: Assets.icons.taskChecklist,
    child: STask(),
  ),
  MNavBarItem(
    title: "S Watch",
    unSelectedIcon: Assets.icons.stopwatch,
    icon: Assets.icons.stopwatch,
    child: SStopwatch(),
  ),

  MNavBarItem(
    title: "Add",
    unSelectedIcon: Assets.icons.add,
    icon: Assets.icons.add,
    child: SAdd(),
  ),
  MNavBarItem(
    title: "Note",
    unSelectedIcon: Assets.icons.notebook,
    icon: Assets.icons.notebook,
    child: SNote(),
  ),
  MNavBarItem(
    title: "Profile",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: SProfile(),
  ),
];
