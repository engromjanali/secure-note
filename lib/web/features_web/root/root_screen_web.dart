import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/web/core_web/util/app_router.dart';
import 'package:secure_note/web/core_web/util/constants/all_enum.dart';
import 'package:secure_note/web/features_web/contact/screens/contact_screen.dart';
import 'package:secure_note/web/features_web/delete_data/secrren/delete_data_screen.dart';
import 'package:secure_note/web/features_web/get_app/screens/get_app_screen.dart';
import 'package:secure_note/web/features_web/home/screens/home_screen.dart';
import 'package:secure_note/web/features_web/privacy_policy/privacy_policy.dart';
import 'package:secure_note/web/helper/responsive_helper.dart';

class RootMaterialScreen extends StatelessWidget {
  const RootMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}







class RootScreenWeb extends StatefulWidget {
  final int pageNo;
  const RootScreenWeb({super.key, this.pageNo =0});

  @override
  State<RootScreenWeb> createState() => _RootScreenWebState();
}

class _RootScreenWebState extends State<RootScreenWeb> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        final String location = GoRouterState.of(context).uri.toString();
        print("-------> ${location}");
        print("-------> done");


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white10,
      body: Row(
        children: [
          /// 🔹 Sidebar
          Container(
            width: ResponsiveHelper.isDesktop(context)? 250 : 70,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(ResponsiveHelper.isDesktop(context)) ...[
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "SecureNote",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                Expanded(
                  child: SingleChildScrollView(
                    child:  Column(
                      children: [
                        _sidebarItem(context, widget.pageNo == 0, Icons.home, "Home", onTap: ()=> AppRouter.getHomeRoute(context,),),
                        _sidebarItem(context, widget.pageNo == 1, Icons.policy, "Privacy Policy", onTap: ()=> AppRouter.getPrivacyPolicyRoute(context, action: RouteAction.pushNamedAndRemoveUntil,)),
                        _sidebarItem(context, widget.pageNo == 2, Icons.auto_delete, "Delete Your Data",onTap: ()=> AppRouter.getDeleteDataRoute( context, action: RouteAction.pushNamedAndRemoveUntil,)),
                        _sidebarItem(context, widget.pageNo == 3, Icons.get_app, "Get App", onTap: ()=> AppRouter.getGetAppRoute(context, action: RouteAction.pushNamedAndRemoveUntil,)),
                        _sidebarItem(context, widget.pageNo == 4, Icons.headset_mic, "Contact", onTap: ()=> AppRouter.getContactRoute(context, action: RouteAction.pushNamedAndRemoveUntil,)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          /// 🔹 Main Content
          Expanded(
            child: Column(
              children: [
                /// 🔸 Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // body
                Expanded(
                  child: 
                      widget.pageNo == 0?
                      HomeScreen()
                      :              
                      widget.pageNo == 1?
                      PrivacyPolicy()
                      :
                      widget.pageNo ==2?
                      DeleteDataScreen()
                      :
                      widget.pageNo ==3?
                      GetAppScreen()
                      :
                      ContactScreen(),              
                ),     
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Sidebar Item
  Widget _sidebarItem(BuildContext context, bool isSelected, IconData icon, String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimension.paddingDefault),
        color: isSelected? Colors.white54 : Colors.black,
        child: Row(
          mainAxisAlignment: ResponsiveHelper.isDesktop(context)? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
        
            if(ResponsiveHelper.isDesktop(context)) ...[
              SizedBox(width: Dimension.paddingDefault),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ]
          ],
        ),
      ),
    );
  }
}