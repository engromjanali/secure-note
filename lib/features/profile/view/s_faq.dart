import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/widgets/w_app_bar.dart';
import 'package:secure_note/features/profile/data/models/m_faq.dart';
import '/core/extensions/ex_padding.dart';
import '/core/widgets/w_container.dart';
import 'package:flutter/material.dart';

class SFaq extends StatefulWidget {
  const SFaq({super.key});

  @override
  State<SFaq> createState() => _SFaqState();
}

class _SFaqState extends State<SFaq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(text: "FAQ", textPositionCenter: true),
      body: SafeArea(
        child: ListView.builder(
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            bool showAns = false;
            return StatefulBuilder(
              builder: (context, setLocalState) {
                return AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: WContainer(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setLocalState(() {
                              showAns = !showAns;
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  faqList[index].question,
                                  style: context.textTheme?.titleSmall,
                                ),
                              ),
                              Icon(
                                showAns ? Icons.expand_less : Icons.expand_more,
                              ),
                            ],
                          ),
                        ).pB(value: showAns ? 10 : 0),
                        if (showAns)
                          Text(
                            faqList[index].ans,
                            style: context.textTheme?.bodySmall,
                          ),
                      ],
                    ),
                  ).pV(),
                );
              },
            );
          },
        ).pAll(),
      ),
    );
  }
}
