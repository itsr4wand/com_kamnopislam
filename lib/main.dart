import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:com_kamnopislam/screens/shop.dart';
import 'package:com_kamnopislam/screens/books.dart';
import 'package:com_kamnopislam/screens/videos.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:com_kamnopislam/screens/prayers.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Battambang',
      ),
      debugShowCheckedModeBanner: false,
      home: const LoaderScreen(),
    );
  }
}

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 6),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xff9D456D),
              Color(0xff0E7391),
            ],
          ),
        ),
        height: double.infinity,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(height: 12.0),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'Koulen',
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText('កំណប់អុិស្លាម'),
                    FadeAnimatedText('កំណប់អុិស្លាម'),
                    FadeAnimatedText('កំណប់អុិស្លាម'),
                  ],
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  letterSpacing: 4.0,
                  fontSize: 20,
                  fontFamily: 'Koulen',
                  color: Color(0xFFFEFEFE),
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText('Kamnop Islam'),
                    FadeAnimatedText('Kamnop Islam'),
                    FadeAnimatedText('Kamnop Islam'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: constant_identifier_names
enum Language { Khmer, English }

enum SampleItem { itemOne, itemTwo }

class _HomeScreenState extends State<HomeScreen> {
  Language selectedLanguage = Language.English; // Default language
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int languageIndex = prefs.getInt('language') ?? 0;
    setState(() {
      selectedLanguage = Language.values[languageIndex];
    });
  }

  void _saveLanguagePreference(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', index);
  }

  SampleItem? selectedMenu;
  late final WebViewController webViewOneController;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();

    webViewOneController = WebViewController()
      ..loadRequest(Uri.parse('https://kamnopislam.blogspot.com'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {},
      );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (selectedLanguage == Language.Khmer)
                ? 'កំណប់អុិស្លាម'
                : 'Kamnop Islam',
            style: const TextStyle(
              color: Color(0xFF019ee0),
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<Language>(
              icon: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: const Color(0xFFe4e6eb),
                  child: const Icon(
                    Icons.translate_outlined,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              position: PopupMenuPosition.under,
              initialValue: selectedLanguage,
              onSelected: (Language lang) {
                setState(() {
                  selectedLanguage = lang;
                  _saveLanguagePreference(
                      lang.index); // Save the selected language in cache
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Language>>[
                const PopupMenuItem<Language>(
                  value: Language.Khmer,
                  child: Text('ភាសាខ្មែរ'),
                ),
                const PopupMenuItem<Language>(
                  value: Language.English,
                  child: Text('English'),
                ),
              ],
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShopScreen(),
                ),
              ),
              icon: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(6.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: const Color(0xFFe4e6eb),
                  child: const Icon(
                    Symbols.shopping_cart,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    color: const Color(0xFFe4e6eb),
                    child: const Icon(
                      Symbols.menu_open,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
        drawer: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.only(right: 10, top: 66, bottom: 40),
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(22.0)),
              child: Drawer(
                width: 300,
                key: scaffoldKey,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: null,
                backgroundColor: const Color(0xFFe4eefd),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ListTile(
                            onTap: () => setState(() {
                              webViewOneController.loadRequest(Uri.parse(
                                  'https://kamnopislam.blogspot.com'));
                              Navigator.pop(context);
                            }),
                            isThreeLine: false,
                            leading: const Icon(Symbols.home),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'ទំព័រដើម'
                                : 'Home'),
                          ),
                          ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrayersScreen(),
                              ),
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.prayer_times),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'អធិស្ឋាន'
                                : 'Prayers'),
                          ),
                          ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VideosScreen(),
                              ),
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.play_arrow),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'វីដេអូ'
                                : 'Videos'),
                          ),
                          ListTile(
                            onTap: () => setState(() {
                              webViewOneController.loadRequest(Uri.parse(
                                  'https://quran.com/1?translations=128%2C792'));
                              Navigator.pop(context);
                            }),
                            isThreeLine: false,
                            leading: const Icon(Symbols.import_contacts),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'ព្រះគម្ពីរ'
                                : 'Quran'),
                          ),
                          ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BooksScreen(),
                              ),
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.local_library),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'សៀវភៅ'
                                : 'Books'),
                          ),
                          ListTile(
                            onTap: () => setState(() {
                              webViewOneController.loadRequest(Uri.parse(
                                  'https://kamnopislam.blogspot.com/p/more.html'));
                              Navigator.pop(context);
                            }),
                            isThreeLine: false,
                            leading: const Icon(Symbols.apps),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'ជាច្រើន'
                                : 'More'),
                          ),
                          const Divider(thickness: 2),
                          ListTile(
                            onTap: () => launchUrl(
                              Uri.parse(
                                  'https://kamnopislam.blogspot.com/p/about.html'),
                              mode: LaunchMode.externalApplication,
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.account_circle),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'អំពីយើង'
                                : 'About us'),
                            subtitle: Text(
                              (selectedLanguage == Language.Khmer)
                                  ? 'យើងជានរណា?'
                                  : 'Who we are?',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            onTap: () => launchUrl(
                              Uri.parse(
                                  'https://kamnopislam.blogspot.com/p/join.html'),
                              mode: LaunchMode.externalApplication,
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.person_add),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'ចូលរួមជាមួយយើង'
                                : 'Join us'),
                            subtitle: Text(
                              (selectedLanguage == Language.Khmer)
                                  ? 'ជួយយើងក្នុងការចែករំលែកសន្តិភាព និងវិបុលភាពក្នុងចំណោមប្រជាជនមុស្លិមទាំងអស់'
                                  : 'Help us to share peace and prosperity among all the Muslims.',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            onTap: () => launchUrl(
                              Uri.parse(
                                  'https://kamnopislam.blogspot.com/p/donate.html'),
                              mode: LaunchMode.externalApplication,
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.volunteer_activism),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'គាំទ្រយើង'
                                : 'Support us'),
                            subtitle: Text(
                              (selectedLanguage == Language.Khmer)
                                  ? 'គាំទ្រការផ្សព្វផ្សាយរបស់កំណប់អុិស្លាម'
                                  : 'Support The Dawah of Kamnop Islam',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            onTap: () => launchUrl(
                              Uri.parse('#'),
                              mode: LaunchMode.externalApplication,
                            ),
                            isThreeLine: false,
                            leading: const Icon(Symbols.star),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'វាយតម្លៃកម្មវិធី!'
                                : 'Rate app!'),
                            subtitle: Text(
                              (selectedLanguage == Language.Khmer)
                                  ? 'វាមានសារៈសំខាន់ជួយឲ្យកម្មវិធីរបស់អ្នកកាន់តែប្រសើរ'
                                  : "It's important helps your app better.",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            onTap: () => Share.share(
                                'check out this nice islam app https://github.com/R4wand-krd/com_kamnopislam'),
                            isThreeLine: false,
                            leading: const Icon(Symbols.share),
                            title: Text((selectedLanguage == Language.Khmer)
                                ? 'ចែករំលែកកម្មវិធី'
                                : 'Share app'),
                            subtitle: Text(
                                (selectedLanguage == Language.Khmer)
                                    ? 'ចែករំលែកទៅកាន់មនុស្សជាទីស្រលាញ់របស់អ្នក'
                                    : "Share to your heart",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                          Text(
                            (selectedLanguage == Language.Khmer)
                                ? 'កំណប់អុិស្លាម'
                                : 'Kamnop Islam',
                            style: const TextStyle(
                              color: Color(0xFF019ee0),
                              fontSize: 16,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          Text(
                            (selectedLanguage == Language.Khmer)
                                ? 'កំណែចុងក្រោយ: 1.0.0'
                                : 'App Version: 1.0.0',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => launchUrl(
                                  Uri.parse('https://vithey.blogspot.com'),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(360.0),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(2.0),
                                    color: const Color(0xFF2b8a3e),
                                    child: const Icon(Symbols.language,
                                        size: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => launchUrl(
                                  Uri.parse('https://youtube.com/@kamnopislam'),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(360.0)),
                                  child: Image.asset(
                                    'assets/icons/youtube.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => launchUrl(
                                  Uri.parse(
                                      'https://www.facebook.com/KamnopIslam?mibextid=2JQ9oc'),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(360.0)),
                                  child: Image.asset(
                                    'assets/icons/facebook.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () => launchUrl(
                                  Uri.parse('https://t.me/kamnopislam'),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(360.0)),
                                  child: Image.asset(
                                    'assets/icons/telegram.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: WebViewWidget(
          controller: webViewOneController,
        ),
      ),
    );
  }
}
