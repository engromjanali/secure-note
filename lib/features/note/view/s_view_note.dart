import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/extensions/ex_padding.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/features/add/view/s_add.dart';
import 'package:flutter/material.dart';

class SViewNote extends StatefulWidget {
  const SViewNote({super.key});

  @override
  State<SViewNote> createState() => _SViewNoteState();
}

class _SViewNoteState extends State<SViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
        actions: [
          IconButton(
            onPressed: () {
              SAdd(isEditPage: true, onlyNote: true).pushReplacement();
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(title, style: context.textTheme?.titleSmall)],
              ).pDivider().pB(),
              Text(details, style: context.textTheme?.bodyMedium).pB(),
              Text("Info", style: context.textTheme?.titleSmall),
              SizedBox.shrink().pDivider(),
              Text(
                "Created At: ${DateTime(2025, 8, 12, 12, 10).format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA)}",
              ),
              Text(
                "Updated At: ${DateTime.now().format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA)}",
              ),
            ],
          ).pAll(),
        ),
      ),
    );
  }
}

String title =
    "About Wikipedia Administration FAQs Assessing article quality Authority";
String details = """
Readers' FAQ About Wikipedia Administrat\nion FAQs 
              Assessing article quality Authority control Categories Censorship Copyright Disambiguation Images and multimedia ISBN Microformats Mobile access Offline access Navigation Other languages Page names Portals Searching Student help
              Researching with Wikipedia
              Citing Wikipedia Readers' glossary
              Readers' index Reader's guide to Wikipedia
              Disambiguation Guideline (talk) Manual of Style (talk)
              Organizing long dabs (talk) Dos and don'ts (talk)
              Organizing dos and don'ts (talk)Reader help (talk)
              {{Disambiguation}}WikiProject (talk)
              CJKV task force (talk)
              Disambig categoryPages in need of cleanup
              Pages with links
              vte Disambiguation pages on Wikipedia are used as a process of resolving conflicts in article titles that occur when a single term can be associated with more than one topic, making that term likely to be the natural title for more than one article. In other words, disambiguation pages are paths leading to different articles which could, in principle, have the same title.
              For example, the word "Mercury" can refer to several things, including an element, a planet, and a Roman god. Since only one Wikipedia page can have the generic name Mercury, unambiguous article titles are used for each of these topics: Mercury (element), Mercury (planet), Mercury (mythology), etc. There must then be a way to direct the reader to the correct specific article when the ambiguous word "Mercury" is referenced by linking, browsing or searching; this is what is 
              Readers' FAQ
              About Wikipedia Administration FAQs Assessing article quality Authority control Categories Censorship Copyright Disambiguation Images and multimedia ISBN Microformats Mobile access Offline access Navigation Other languages Page names Portals Searching Student help
              Researching with Wikipedia
              Citing Wikipedia
              Readers' glossary
              Readers' index
              Reader's guide to Wikipedia
              Disambiguation
              Guideline (talk)
              Manual of Style (talk)
              Organizing long dabs (talk)
              Dos and don'ts (talk)
              Organizing dos and don'ts (talk)
              Reader help (talk)
              {{Disambiguation}}
              WikiProject (talk)
              CJKV task force (talk)
              Disambig category
              Pages in need of cleanup
              Pages with links
              vte
              Disambiguation pages on Wikipedia are used as a process of resolving conflicts in article titles that occur when a single term can be associated with more than one topic, making that term likely to be the natural title for more than one article. In other words, disambiguation pages are paths leading to different articles which could, in principle, have the same title.
              
              For example, the word "Mercury" can refer to several things, including an element, a planet, and a Roman god. Since only one Wikipedia page can have the generic name Mercury, unambiguous article titles are used for each of these topics: Mercury (element), Mercury (planet), Mercury (mythology), etc. There must then be a way to direct the reader to the correct specific article when the ambiguous word "Mercury" is referenced by linking, browsing or searching; this is what is 
              Readers' FAQ
              About Wikipedia Administration FAQs Assessing article quality Authority control Categories Censorship Copyright Disambiguation Images and multimedia ISBN Microformats Mobile access Offline access Navigation Other languages Page names Portals Searching Student help
              Researching with Wikipedia
              Citing Wikipedia
              Readers' glossary
              Readers' index
              Reader's guide to Wikipedia
              Disambiguation
              Guideline (talk)
              Manual of Style (talk)
              Organizing long dabs (talk)
              Dos and don'ts (talk)
              Organizing dos and don'ts (talk)
              Reader help (talk)
              {{Disambiguation}}
              WikiProject (talk)
              CJKV task force (talk)
              Disambig category
              Pages in need of cleanup
              Pages with links
              vte
              Disambiguation pages on Wikipedia are used as a process of resolving conflicts in article titles that occur when a single term can be associated with more than one topic, making that term likely to be the natural title for more than one article. In other words, disambiguation pages are paths leading to different articles which could, in principle, have the same title.
              
              For example, the word "Mercury" can refer to several things, including an element, a planet, and a Roman god. Since only one Wikipedia page can have the generic name Mercury, unambiguous article titles are used for each of these topics: Mercury (element), Mercury (planet), Mercury (mythology), etc. There must then be a way to direct the reader to the correct specific article when the ambiguous word "Mercury" is referenced by linking, browsing or searching; this is what is""";
