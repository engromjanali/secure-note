import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:secure_note/web/features_web/privacy_policy/privacy_policy_data.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    // convart to remote data fetching 
    return SingleChildScrollView(child: Html(data: htmlData));
  }
}