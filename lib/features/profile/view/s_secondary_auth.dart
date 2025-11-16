import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:flutter/material.dart';

class SSAuth extends StatefulWidget {
  const SSAuth({super.key});

  @override
  State<SSAuth> createState() => _SSAuthState();
}

class _SSAuthState extends State<SSAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Secondary Authentication",
                style: context.textTheme?.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
