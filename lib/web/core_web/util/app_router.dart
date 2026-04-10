import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_note/example.dart';
import 'package:secure_note/web/core_web/util/constants/all_enum.dart';
import 'package:secure_note/web/features_web/root/root_screen_web.dart';



class AppRouter {

  static String getHomeRoute(BuildContext context) => _navigateRoute(context, '/', route: RouteAction.pushNamedAndRemoveUntil);
  static String getPrivacyPolicyRoute(BuildContext context,  {dynamic data, RouteAction ? action}) => _navigateRoute(context, '/privacy-Policy', route: action);
  static String getDeleteDataRoute(BuildContext context, {dynamic data, RouteAction ? action}) => _navigateRoute(context, '/delete-data', route: action);
  static String getGetAppRoute(BuildContext context, {dynamic data, RouteAction ? action}) => _navigateRoute(context, '/get-app', route: action);
  static String getContactRoute(BuildContext context, {dynamic data, RouteAction ? action}) => _navigateRoute(context, '/contact', route: action);



  static String _navigateRoute(BuildContext? context, String path,{RouteAction? route = RouteAction.push}) {
    if(route == RouteAction.pushNamedAndRemoveUntil){
      Get.context?.go(path);
    }else if(route == RouteAction.pushReplacement){
      Get.context?.pushReplacement(path);
    }
    else{
      Get.context?.push(path);
    }

    return path;
  }

  static GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/example',
        builder: (context, state) => const ExampleScreen(),
      ),

      /// 🔹 Root (Dashboard)
      GoRoute(
        path: '/',
        builder: (context, state) => const RootScreenWeb(),
      ),

      /// 🔹 Privacy Policy
      GoRoute(
        path: '/privacy-Policy',
        builder: (context, state) => const RootScreenWeb(pageNo: 1,),
      ),

      /// 🔹 Delete Data
      GoRoute(
        path: '/delete-data',
        builder: (context, state) => const RootScreenWeb(pageNo: 2,),
      ),

      /// 🔹 Download Page
      GoRoute(
        path: '/get-app',
        builder: (context, state) => const RootScreenWeb(pageNo: 3,),
      ),

      // 🔹 Support Page
      GoRoute(
        path: '/contact',
        builder: (context, state) => const RootScreenWeb(pageNo: 4,),
        routes: [
          // 🔹 Support Page
          // GoRoute(
          //   path: 'example',
          //   builder: (context, state) => const ExampleScreen(),
          // ),
        ]
      ),

      // 🔹 Support Page


    ],
  );
}

