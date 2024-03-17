import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/Firebase/firebaseLogout.dart';
import 'package:cryptkey/data/clearHiveData.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/screens/authenticationPage.dart';
import 'package:cryptkey/utils/clearSharedData.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customTiles.dart';
import 'package:cryptkey/widgets/routeBuilder.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = FirebaseAuth.instance.currentUser!.displayName!;
  String userEmail = FirebaseAuth.instance.currentUser!.email!;
  String userPhoto = FirebaseAuth.instance.currentUser!.photoURL!;
  @override
  Widget build(BuildContext context) {
    final navigation = Navigator.of(context);
    final mycontext = context;
    return Consumer<ScreenProvider>(
      builder: (BuildContext context, provider, child) {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 2, 18, 46),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 2, 18, 46),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.setPlatforms();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Hero(
                      tag: 'user',
                      child: ClipOval(
                        child: CachedNetworkImage(
                          width: 80,
                          height: 80,
                          imageUrl: userPhoto,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Image.asset('assets/icons/others.png'),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.values[2],
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
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTile().customTile(
                    "Clear Data", "Clear all your data", Icons.circle_outlined,
                    () async {
                  try {
                    final bool result =
                        await ShowConfirmationWidget.showConfirmationDialog(
                            context,
                            "Clear Data",
                            "Are you sure you want to clear all  data?");
                    if (result) {
                      navigation.pop();

                      await CloudFirestoreService().clearData();
                      ClearHiveData.clearData();
                      provider.setPlatforms();
                      provider.setPlatforms();

                      ToastMessage.showToast("Data Cleared");
                    }
                  } catch (e) {
                    ToastMessage.showToast("Error Occurred");
                  }
                }),
                CustomTile().customTile("Privacy Policy", "App Privacy Policy",
                    Icons.privacy_tip_outlined, () {}),
                CustomTile().customTile("About", "App and Developer Details",
                    Icons.details_outlined, () {}),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      if (!await InternetConnectionChecker().hasConnection) {
                        ToastMessage.showToast("Please Check Your Internet");
                      } else {
                        if (context.mounted) {
                          if (await ShowConfirmationWidget
                              .showConfirmationDialog(mycontext, "Logout",
                                  "Do you want to logout?")) {
                            ClearSharedData().clearSharedData();

                            await FirebaseLogout.logout();
                            ClearHiveData.clearData();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                AnimatedRouteBuilder(
                                        anotherPage: const AuthenticationPage())
                                    .animatedRoute(),
                              );
                            }
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red, fontSize: 17),
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ));
      },
    );
  }
}
