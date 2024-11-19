import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/Firebase/firebaseLogout.dart';
import 'package:cryptkey/data/clearHiveData.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/screens/authenticationPage.dart';
import 'package:cryptkey/screens/setEncryptionPin.dart';
import 'package:cryptkey/utils/clearSharedData.dart';
import 'package:cryptkey/utils/isGuestUser.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/changePinScreen.dart';
import 'package:cryptkey/widgets/customTiles.dart';
import 'package:cryptkey/widgets/developerCard.dart';
import 'package:cryptkey/widgets/routeBuilder.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Firebase/firebaseLogin.dart';
import '../utils/mobileAuth.dart';
import '../widgets/confirmPin.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = "Guest User";
  String userEmail = "guest@cryptkey.com";
  String userPhoto = "assets/icons/others.svg";

  pop() {
    Navigator.pop(context);
  }

  setUserDetails() {
    username = FirebaseAuth.instance.currentUser!.displayName!;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    userPhoto = FirebaseAuth.instance.currentUser!.photoURL!;
  }

  navigateToOtherScreen() {
    Navigator.pushReplacement(
      context,
      AnimatedRouteBuilder(anotherPage: const AuthenticationPage())
          .animatedRoute(),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!isGuestUser()) {
      setUserDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenProvider>(
      builder: (BuildContext context, provider, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 2, 18, 46),
            leading: IconButton(
              onPressed: () {
                if (!provider.isLoading) {
                  Navigator.pop(context);
                  provider.setPlatforms();
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Hero(
                      tag: 'user',
                      child: ClipOval(
                        child: !isGuestUser()
                            ? CachedNetworkImage(
                                width: 80,
                                height: 80,
                                imageUrl: userPhoto,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/icons/others.png'),
                              )
                            : SvgPicture.asset(
                                "assets/icons/others.svg",
                                height: 40,
                                width: 40,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.062,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userEmail,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 30),
                FirebaseAuth.instance.currentUser != null
                    ? CustomTile().customTile(
                        "Clear Data",
                        "Clear all your data",
                        Icons.circle_outlined,
                        () async {
                          if (!provider.isLoading) {
                            provider.isLoadingAuth(true);
                            try {
                              bool res = false;
                              if (await MobileAuth.canAuthenticate()) {
                                res = await MobileAuth.authenticate(
                                    "Confirm to Clear Data");
                              } else {
                                res = (await showConfirmPinDialog(
                                        context, provider.screenpin ?? "")) ??
                                    false;
                              }
                              if (res &&
                                  await ShowConfirmationWidget
                                      .showConfirmationDialog(
                                          context,
                                          "Clear Data",
                                          "Are you sure you want to clear all data?")) {
                                if (provider.platformsList.isEmpty) {
                                  ToastMessage.showToast("No Data Found");
                                } else {
                                  await CloudFirestoreService().clearData();
                                  ClearHiveData.clearData();
                                  provider.emptyData();
                                  ToastMessage.showToast("Data Cleared");
                                }
                                pop();
                              } else {
                                ToastMessage.showToast("Cannot Clear Data");
                              }
                            } catch (e) {
                              ToastMessage.showToast("Unable to Clear Data");
                            } finally {
                              provider.isLoadingAuth(false);
                            }
                          }
                        },
                      )
                    : SizedBox(),
                CustomTile().customTile(
                    "Change Screen Pin", "Screen Pin", Icons.password_rounded,
                    () {
                  if (!provider.isLoading) {
                    if (provider.screenpin != null &&
                        provider.screenpin != "") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePinScreen(
                                heading: "Change Screen Pin",
                                oldPin: provider.screenpin!)),
                      );
                    }
                  }
                }),
                FirebaseAuth.instance.currentUser != null
                    ? CustomTile().customTile(
                        "Change Encryption Pin", "Encryption Pin", Icons.pin,
                        () {
                        if (!provider.isLoading) {
                          if (provider.screenpin != null &&
                              provider.screenpin != "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePinScreen(
                                      heading: "Change Encryption Pin",
                                      oldPin: provider.encryptionpin!)),
                            );
                          }
                        }
                      })
                    : SizedBox(),
                CustomTile().customTile("Privacy Policy", "App Privacy Policy",
                    Icons.privacy_tip_outlined, () async {
                  if (!provider.isLoading) {
                    const String url =
                        "https://rohankarn69.github.io/privacy_cryptkey/";
                    if (!await launch(url)) {
                      throw Exception('Could not launch $url');
                    }
                  }
                }),
                CustomTile().customTile(
                    "About", "Developer Details", Icons.details_outlined, () {
                  showDeveloperCard(context);
                }),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    if (!provider.isLoading) {
                      provider.isLoadingAuth(true);
                      try {
                        if (!isGuestUser()) {
                          if (!await InternetConnectionChecker()
                              .hasConnection) {
                            ToastMessage.showToast(
                                "Please Check Your Internet");
                          } else if (await ShowConfirmationWidget
                              .showConfirmationDialog(context, "Logout",
                                  "Do you want to logout?")) {
                            await UploadToCloud().uploadToCloud();
                            ClearSharedData().clearSharedData();
                            await FirebaseLogout.logout();
                            ClearHiveData.clearData();
                            navigateToOtherScreen();
                          }
                        } else {
                          await LoginService.login();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('isFirst', true);
                          if (FirebaseAuth.instance.currentUser != null) {
                            final bool doesExist =
                                await CloudFirestoreService().checkAndAddUser();
                            Navigator.pushReplacement(
                                context,
                                AnimatedRouteBuilder(
                                    anotherPage: SetEncryptionPin(
                                  doesExist: doesExist,
                                )).animatedRoute());
                          } else {
                            ToastMessage.showToast("An error occurred");
                          }
                        }
                      } catch (error) {
                        ToastMessage.showToast("An error occurred");
                      } finally {
                        provider.isLoadingAuth(false);
                      }
                    }
                  },
                  child: Text(
                    isGuestUser() ? "Connect Google Account" : "Logout",
                    style: TextStyle(
                        color: isGuestUser() ? Colors.white : Colors.red,
                        fontSize: 17),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
