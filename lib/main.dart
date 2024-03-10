import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/screens/authenticationPage.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/screens/userPage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PasswordManagerModelAdapter());
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<PasswordManagerModel>('cryptoKeyBox');

  runApp(const MyApp());
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
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CryptKey',
          home: AuthenticationPage()),
    );
  }
}
