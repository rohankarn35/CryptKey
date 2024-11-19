import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/firebase_options.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/screens/getStarted.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive.registerAdapter(PasswordManagerModelAdapter());
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<PasswordManagerModel>('cryptoKeyBox');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isGetStarted = prefs.getBool("isGetStarted") ?? false;
  final pin = prefs.getString("pin");

  bool pinExist = true;
  if (pin == null) {
    pinExist = false;
  }

  runApp(MyApp(
    isGetStarted: isGetStarted,
    pinexist: pinExist,
  ));
}

class MyApp extends StatelessWidget {
  final bool isGetStarted;
  final bool pinexist;

  const MyApp({super.key, required this.isGetStarted, required this.pinexist});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WidgetProvider()),
        ChangeNotifierProvider(create: (_) => ScreenProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CryptKey',
          theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: const Color.fromARGB(255, 2, 18, 46),
          ),
          home: isGetStarted ? const HomePage() : const GetStartedPage()),
    );
  }
}
