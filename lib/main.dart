import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.initFlutter();

  Hive.registerAdapter(PasswordManagerModelAdapter());
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<PasswordManagerModel>('cryptoKeyBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          home: UpgradeAlert(
            child: SplashScreen(),
          ),
        )
        // home: SetEncryptionPin(doesExist: true)),
        );
  }
}
