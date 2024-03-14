import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/firebase_options.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/screens/authenticationPage.dart';
import 'package:cryptkey/screens/getStarted.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/screens/setEncryptionPin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CryptKey',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 2, 18, 46),
        

        ),
        // home: FirebaseAuth.instance.currentUser != null
        //     ? const HomePage()
        //     : const AuthenticationPage(),

        home: SetEncryptionPin(),
      ),
    );
  }
}
