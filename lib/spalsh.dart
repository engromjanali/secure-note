import 'package:daily_info/core/controllers/c_check_point.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/local_auth_services.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    printer("value");
    if (true || await LocalAuthServices().showBiometric()) {
      final CCheckPoint checkPoint = CCheckPoint();
      checkPoint.initialization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: checkAuth,
        child: Container(
          color: Colors.black,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    Assets.images.logo.path,
                    height: 300.w,
                    width: 300.w,
                  ),
                ),
              ),
              Text(
                "Loading...",
                style: context.textTheme?.titleSmall?.copyWith(
                  color: Colors.white,
                ),
              ).pB(value: 50),
            ],
          ),
        ),
      ),
    );
  }
}
