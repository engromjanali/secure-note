import 'dart:io';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/nav/models/bottom_items.dart';
import 'package:secure_note/core/widgets/nav/widgets/nav_bar_widget.dart';
import 'package:secure_note/core/widgets/w_dialog.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SHome extends StatefulWidget {
  final int selectedPage;
  const SHome({super.key, this.selectedPage = 1});

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  final ValueNotifier currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex.value = widget.selectedPage;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) {
        WDialog.confirmExitLogout(
          title: "Exit the App",
          description: "Are you sure you want to exit the app?",
          isLogOut: false,
          context: context,
          onYesPressed: () {
            SystemNavigator.pop();
            exit(0);
          },
        );
      },
      child: Scaffold(
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (context, value, _) {
            return WNavigationBar(
              items: homeNevItem,
              currentIndex: value,
              onChanged: (index) {
                if (index == 2) {
                  SAdd().push();
                  return;
                }
                currentIndex.value = index;
              },
            );
          },
        ),
        body: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (_, _, _) => homeNevItem[currentIndex.value].child!,
        ),
      ),
    );
  }
}
