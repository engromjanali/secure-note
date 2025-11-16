import 'package:daily_info/gen/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class WNoDataFound extends StatelessWidget {
  const WNoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.logo.emptyData, height: 300.h);
  }
}
