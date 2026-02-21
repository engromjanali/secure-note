import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.go("/contact/example");
          // context.pop();

          if(context.canPop()){
            print("-state--> ${GoRouterState.of(context).fullPath}");
          }
        }, child: Text("go to example screen")
      ),
    );
  }
}