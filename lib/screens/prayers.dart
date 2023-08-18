import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class PrayersScreen extends StatefulWidget {
  const PrayersScreen({super.key});

  @override
  State<PrayersScreen> createState() => _PrayersScreenState();
}

class _PrayersScreenState extends State<PrayersScreen> {
  Language selectedLanguage = Language.English; // Default language

  void _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int languageIndex = prefs.getInt('language') ?? 0;
    setState(() {
      selectedLanguage = Language.values[languageIndex];
    });
  }

  late final WebViewController webViewTwoController;
  int? _value = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();

    webViewTwoController = WebViewController()
      ..loadRequest(
          Uri.parse('https://www.islamicity.org/prayertimes/index-mobile.php'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (selectedLanguage == Language.Khmer) ? 'ថយក្រោយ' : 'Back',
          style: const TextStyle(
            color: Color(0xFF019ee0),
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  (selectedLanguage == Language.Khmer)
                      ? 'ការអធិស្ឋាន'
                      : 'Prayers',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Wrap(
                  spacing: 4,
                  children: List<Widget>.generate(
                    2,
                    (int index) {
                      return ChoiceChip(
                        avatar: Icon(
                            index == 0 ? Symbols.schedule : Symbols.explore),
                        label: Text(index == 0
                            ? (selectedLanguage == Language.Khmer)
                                ? 'ពេលវេលាអធិស្ឋាន'
                                : 'Time'
                            : (selectedLanguage == Language.Khmer)
                                ? 'ទិសអធិស្ឋាន'
                                : 'Qibla'),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? index : -1;
                          });
                          if (selected) {
                            if (index == 0) {
                              // Show when the Time ChoiceChip is clicked
                              webViewTwoController.loadRequest(Uri.parse(
                                  'https://www.islamicity.org/prayertimes/index-mobile.php'));
                            } else if (index == 1) {
                              // Show when the Qibla ChoiceChip is clicked
                              webViewTwoController.loadRequest(Uri.parse(
                                  'https://qiblafinder.withgoogle.com/intl/en/finder/ar'));
                            } else {
                              // Show when nothing is selected
                              webViewTwoController.loadRequest(Uri.parse(
                                  'https://www.islamicity.org/prayertimes/index-mobile.php'));
                            }
                          } else {
                            // Show when nothing is selected
                            webViewTwoController.loadRequest(Uri.parse(
                                'https://www.islamicity.org/prayertimes/index-mobile.php'));
                          }
                        },
                        shape: const StadiumBorder(
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFa6a6a6),
                          width: 1.0,
                        ),
                        selectedColor: const Color.fromRGBO(1, 158, 224, 0.5),
                        backgroundColor: const Color.fromRGBO(1, 158, 224, 0.1),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: WebViewWidget(
        controller: webViewTwoController,
      ),
    );
  }
}
