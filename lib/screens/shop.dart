import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Language selectedLanguage = Language.English; // Default language

  void _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int languageIndex = prefs.getInt('language') ?? 0;
    setState(() {
      selectedLanguage = Language.values[languageIndex];
    });
  }

  late final WebViewController webViewTwoController;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();

    webViewTwoController = WebViewController()
      ..loadRequest(
          Uri.parse('https://kamnopislam.blogspot.com/search/label/Product'))
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
        automaticallyImplyLeading: true,
        titleSpacing: 6,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back),
        ),
      ),
      body: WebViewWidget(
        controller: webViewTwoController,
      ),
    );
  }
}
