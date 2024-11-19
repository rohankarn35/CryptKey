import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/Firebase/firebaseLogin.dart';
import 'package:cryptkey/Firebase/firebaseLogout.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/screens/biometricPage.dart';
import 'package:cryptkey/screens/setEncryptionPin.dart';
import 'package:cryptkey/utils/navigation.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/routeBuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  // bool _isLoading = false;
  @override
  void initState() {
    FirebaseLogout.logout();
    super.initState();
  }

  // navigateToHomePage() {
  //   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         return const HomePage();
  //       },
  //     ),
  //     (_) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          actions: [
            TextButton(
              onPressed: () {
                navigateToPage(context, BiometricPage());
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 2, 18, 46),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
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
                            onPressed: () async {},
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
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isFirst', true);
                                if (FirebaseAuth.instance.currentUser != null) {
                                  final bool doesExist =
                                      await CloudFirestoreService()
                                          .checkAndAddUser();
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        AnimatedRouteBuilder(
                                            anotherPage: SetEncryptionPin(
                                          doesExist: doesExist,
                                        )).animatedRoute());
                                  }
                                } else {
                                  ToastMessage.showToast("An error occurred");
                                }
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
                                    const Text(
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
      ),
    );
  }
}
