import 'package:cryptkey/Firebase/firebaseLogin.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 18, 46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            const Text(
              'CryptKey',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your Password Manager',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Consumer<ScreenProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: provider.isLoading
                      ? OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    height: 30,
                                    child: JumpingDots(
                                      color: Colors.white,
                                      numberOfDots: 3,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () async {
                            provider.isLoadingAuth(true);
                            try {
                              await LoginService.login();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            } catch (error) {
                              ToastMessage.showToast("An error occurred ");
                            } finally {
                              provider.isLoadingAuth(false);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  Image.asset(
                                    'assets/icons/google.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
            // const SizedBox(
            //   height: 40,
            // ),
          ],
        ),
      ),
    );
  }
}
