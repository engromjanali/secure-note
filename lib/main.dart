import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:secure_note/core/controllers/c_theme.dart';
import 'package:secure_note/core/data/local/db_local.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/functions/f_default_scrolling.dart';
import 'package:secure_note/core/services/encryption_service.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/services/shared_preference_service.dart';
import 'package:secure_note/firebase_options.dart';
import 'package:secure_note/spalsh.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';
import 'package:secure_note/web/features_web/delete_data/controller/delete_data_controller.dart';
import 'package:secure_note/web/features_web/root/root_screen_web.dart';
import 'package:secure_note/web/helper/responsive_helper.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  if(kIsWeb){
    usePathUrlStrategy();
    PowerVault.put(DeleteDataController());
    runApp(const RootMaterialScreen());
    return;
  }
  
  await _init();
  runApp(
    // DevicePreview(enabled: !kReleaseMode, builder: (context) => _SCheckPoint()),
    DevicePreview(enabled: false, builder: (context) => _SCheckPoint()),
  );
  // runApp(const _SCheckPoint());
}

// MyDebugToken D13CC233-97A1-42A1-A511-EC15AF3995E6
Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug,
    // set to true to use the default providers configured in console
    // webProvider: ReCaptchaV3Provider('your-site-key'), // only for web if applicable
  );
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
    Size size  = MediaQuery.of(context).size;
    return PowerBuilder<CTheme>(
      builder: (CTheme controller) {
        return ScreenUtilInit(
          designSize: ResponsiveHelper.isMobile(context) ? Size(430, 932) : size,
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
            );
          },
        );
      },
    );
  }
}
