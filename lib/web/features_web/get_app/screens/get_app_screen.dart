import 'package:flutter/material.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/functions/f_url_launcher.dart';

class GetAppScreen extends StatefulWidget {
  const GetAppScreen({super.key});

  @override
  State<GetAppScreen> createState() => _GetAppGetAppScreenState();
}

class _GetAppGetAppScreenState extends State<GetAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The App was not publish yet!")));
          // OpenURLs.open(type: OpenType.url, value: "Https://");
        }, child: Text("Download"))
      ],
    );
  }
}