import 'package:daily_info/features/add/view/s_add.dart';
import 'package:daily_info/features/note/view/s_note.dart';
import 'package:daily_info/features/profile/view/s_profile.dart';
import 'package:daily_info/features/profile/view/s_profile.dart';
import 'package:daily_info/features/stopwatch/view/s_stopwatch.dart';
import 'package:daily_info/features/task/view/s_task.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'm_nav_bar_item.dart';

List<MNavBarItem> homeNevItem = [
  MNavBarItem(
    title: "Task",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: STask(),
  ),
  MNavBarItem(
    title: "S Watch",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: SStopwatch(),
  ),

  MNavBarItem(
    title: "Add",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.faq,
    child: SAdd(),
  ),
  MNavBarItem(
    title: "Note",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: SNote(),
  ),
  MNavBarItem(
    title: "Profile",
    unSelectedIcon: Assets.icons.profile,
    icon: Assets.icons.profile,
    child: SProfile(),
  ),
];
