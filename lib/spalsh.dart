import 'package:daily_info/core/controllers/c_check_point.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/local_auth_services.dart';
import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    if (await LocalAuthServices().showBiometric()) {
      final CCheckPoint checkPoint = CCheckPoint();
      checkPoint.initialization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: checkAuth,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  Assets.logo.logo,
                  height: 200.w,
                  width: 200.w,
                  colorFilter: ColorFilter.mode(
                    context.primaryTextColor!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              "Loading...",
              style: context.textTheme?.titleSmall?.copyWith(
                color: context.primaryTextColor,
              ),
            ).pB(value: 50),
          ],
        ),
      ),
    );
  }
}
