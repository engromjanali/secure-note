import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    print("go router sate ${GoRouterState.of(context).path}");
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          context.pop();
        }, child: Text("Back")),
      ),
    );
  }
}