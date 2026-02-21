import 'package:flutter/material.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/web/features_web/delete_data/secrren/delete_data_screen.dart';
import 'package:secure_note/web/features_web/privacy_policy/privacy_policy.dart';
import 'package:secure_note/web/helper/responsive_helper.dart';

class RootMaterialScreen extends StatelessWidget {
  const RootMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootScreenWeb(),
    );
  }
}

class RootScreenWeb extends StatefulWidget {
 const RootScreenWeb({super.key});

  @override
  State<RootScreenWeb> createState() => _RootScreenWebState();
}

class _RootScreenWebState extends State<RootScreenWeb> {
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {

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
                    child: ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder: (context ,value,_) {
                        return Column(children: [
                          _sidebarItem(context, value == 0, Icons.home, "Home", onTap: ()=> selectedIndex.value = 0),
                          _sidebarItem(context, value == 1, Icons.policy, "Privacy Policy", onTap: ()=> selectedIndex.value = 1),
                          _sidebarItem(context, value == 2, Icons.auto_delete, "Delete Your Data",onTap: ()=> selectedIndex.value = 2),
                          _sidebarItem(context, value == 3, Icons.get_app, "Get App", onTap: ()=> selectedIndex.value = 3),
                          _sidebarItem(context, value == 4, Icons.headset_mic, "Contact", onTap: ()=> selectedIndex.value = 4),
                        ]);
                      }
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
                  child: ValueListenableBuilder(
                   valueListenable: selectedIndex,
                    builder: (context ,value,_) {
                      switch (value){
                        case 0:
                          return PrivacyPolicy();
                        case 1:
                          return PrivacyPolicy();
                        case 2:
                          return DeleteDataScreen();
                        case 3:
                          return PrivacyPolicy();
                        default:
                          return PrivacyPolicy();
                      } 
                    }
                  ),
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

  /// 🔹 Note Card
  Widget _noteCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note ${index + 1}",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "This is a sample secure note preview. Your encrypted data stays safe.",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          const Row(
            children: [
              Icon(Icons.lock, size: 16),
              SizedBox(width: 5),
              Text("Encrypted"),
            ],
          )
        ],
      ),
    );
  }
}