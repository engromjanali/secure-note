import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:secure_note/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.logo.appIcon.path,
              height: 100,
              width: 100,
            ),
            Text("The site in under build!"),
            Text("We will back with a new release as soon as possible"),
          ],
        ),
      ),
    );
  }
}