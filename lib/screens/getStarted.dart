import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cryptkey/screens/authenticationPage.dart';
import 'package:cryptkey/widgets/routeBuilder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              "assets/icons/get.png",
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.88,
            ),
            const Text(
              "Welcome to CryptKey",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            AnimatedTextKit(animatedTexts: [
              TypewriterAnimatedText(
                'Generate strong passwords',
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Store Passwords Securely',
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Access Passwords Anywhere',
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ]),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isGetStarted", true);
                  if(!context.mounted ) return;

                  
                  Navigator.pushReplacement(
                    context,
                    AnimatedRouteBuilder(anotherPage: const AuthenticationPage())
                        .animatedRoute(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Adjust text color as needed
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
