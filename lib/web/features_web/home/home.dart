import 'package:flutter/material.dart';
import 'package:secure_note/web/helper/responsive_helper.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [
          /// 🔹 Sidebar
          Container(
            width: ResponsiveHelper.isDesktop(context)? 250 : 50,
            height: double.infinity,
            color: Colors.black87,
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
                        color: Colors.white,
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

                /// 🔸 Notes Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      itemCount: 8,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return _noteCard(index);
                      },
                    ),
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
    return Container(
      color: isSelected? Colors.black : null,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: ResponsiveHelper.isDesktop(context)? Text(
          title,
          style: const TextStyle(color: Colors.white),
        ) : null,
        onTap: onTap,
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
