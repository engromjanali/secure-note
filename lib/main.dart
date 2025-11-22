import 'package:daily_info/core/controllers/c_theme.dart';
import 'package:daily_info/core/data/local/db_local.dart';
import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/functions/f_default_scrolling.dart';
import 'package:daily_info/core/services/encryption_service.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/services/shared_preference_service.dart';
import 'package:daily_info/example.dart';
import 'package:daily_info/firebase_options.dart';
import 'package:daily_info/spalsh.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';

void main() async {
  await init();
  runApp(
    // DevicePreview(enabled: !kReleaseMode, builder: (context) => _SCheckPoint()),
    DevicePreview(enabled: true, builder: (context) => _SCheckPoint()),
  );
  // runApp(const _SCheckPoint());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   await CNotification().requestPermission();
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  //   await CNotification().initNotification();
  // init base method otherwise we may get an error like "xyz was not initialized".
  await SharedPrefService.instance.init();
  await EncryptionService().init();
  await DBHelper.getInstance.init();
}

class _SCheckPoint extends StatefulWidget {
  const _SCheckPoint();

  @override
  State<_SCheckPoint> createState() => __SCheckPointState();
}

class __SCheckPointState extends State<_SCheckPoint> {
  final CTheme themeController = PowerVault.put(CTheme());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PowerBuilder<CTheme>(
      builder: (CTheme controller) {
        return ScreenUtilInit(
          designSize: kIsWeb ? Size(430, 932) : Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          fontSizeResolver: (fontSize, screenUtil) {
            if (kIsWeb) {
              // On web: ignore scaling, just use original fontSize
              return fontSize.toDouble();
            } else {
              // On mobile: use normal scaled fontSize
              return fontSize * // orginial font size.
                  screenUtil.scaleWidth * // screen wise scale factor
                  screenUtil.textScaleFactor; // user devices text scale factor
            }
          },
          builder: (ctx, _) {
            return MaterialApp(
              locale: DevicePreview.locale(ctx),
              navigatorObservers: [NavigationService.routeObserver],
              debugShowCheckedModeBanner: false,
              navigatorKey: NavigationService.key,
              theme: controller.themeList.first,
              darkTheme: controller.themeList.last,
              themeMode: ThemeMode.system,
              builder: (contxt, child) {
                child = DevicePreview.appBuilder(contxt, child);

                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness:
                        contxt.theme.brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
                  ),
                  child: ScrollConfiguration(
                    behavior: PScrollBehavior(),
                    child: kIsWeb
                        ? Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 480,
                              ), // ✅ adjust width here
                              child: child!,
                            ),
                          )
                        : child!,
                  ),
                );
              },

              home: SpalshScreen(),
              // home: InfinityScroll(),
            );
          },
        );
      },
    );
  }
}
