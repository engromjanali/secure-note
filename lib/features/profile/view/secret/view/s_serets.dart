import 'package:secure_note/core/constants/colors.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/profile/view/secret/controller/c_passkey.dart';
import 'package:secure_note/features/profile/view/secret/controller/c_sceret.dart';
import 'package:secure_note/features/profile/view/secret/view/s_add_passkey.dart';
import 'package:secure_note/features/profile/view/secret/widgets/w_secret_section.dart';
import 'package:secure_note/features/profile/view/secret/widgets/w_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';

class SSerets extends StatefulWidget {
  const SSerets({super.key});

  @override
  State<SSerets> createState() => _SSeretsState();
}

class _SSeretsState extends State<SSerets> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<String> tabs = const ['Notes', 'PassKeys'];
  final List<Icon> icons = const [Icon(Icons.list_alt), Icon(Icons.create)];
  final List<Widget> items = [_SecretNote(isSecret: true), _SecretNote()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    printer("dispose secret");
    _tabController?.dispose();
    PowerVault.delete<CSecret>();
    PowerVault.delete<CPasskey>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Secret Note")),
      floatingActionButton: WFloatingActionButton(
        onTap: (index) {
          printer(index);
          if (index == 2) {
            SAPasskey().push();
          } else if (index == 1) {
            SAdd(onlyNote: true, isSecret: true).push();
          }
        },
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, scrollable) {
          return [
            SliverAppBar(
              title: AnimatedBuilder(
                animation: _tabController!,
                builder: (context, child) {
                  return Text(tabs[_tabController!.index]);
                },
              ),
              actions: [],
              floating: true,
              snap: true,
              pinned: true,
              elevation: 0,
              bottom: TabBar(
                mouseCursor: MouseCursor.uncontrolled,
                automaticIndicatorColorAdjustment: false,
                controller: _tabController,
                isScrollable: true, // must assign otherwise get an error
                tabAlignment: TabAlignment.start,
                labelColor: context.primaryTextColor,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: context.primaryTextColor,
                unselectedLabelColor: context.primaryTextColor?.withAlpha(200),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                tabs: tabs
                    .map(
                      (e) =>
                          Tab(text: e.toString(), icon: icons[tabs.indexOf(e)]),
                    )
                    .toList(),
              ),
            ),
          ];
        },

        body: TabBarView(controller: _tabController, children: items),
      ),
    );
  }
}

class _SecretNote extends StatelessWidget {
  final bool isSecret;
  const _SecretNote({super.key, this.isSecret = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_sharp),
            hintText: "Search ${isSecret ? "Note" : "Passkeys"} Here",
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.tune_rounded),
            ),
          ),
        ).pB(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              if (isSecret) {
                printer("cSecret find");
                CSecret cSecret = PowerVault.find<CSecret>();
                cSecret.clear();
                cSecret.fetchSecret();
              } else {
                printer("cPasskey find");
                CPasskey cPasskey = PowerVault.find<CPasskey>();
                cPasskey.clear();
                cPasskey.fetchPasskey();
              }
            },
            color: context.primaryTextColor,
            backgroundColor: context.fillColor,
            child: Column(
              children: [
                if (isSecret)
                  WSecretSection(
                    leadingColor: PColors.pendingColor,
                    asSliver: true,
                  ),
                if (!isSecret)
                  WSecretSection(
                    leadingColor: PColors.completedColor,
                    asSliver: true,
                    isSecretNote: false,
                  ),
              ],
            ),
          ),
        ),
      ],
    ).pAll();
  }
}
