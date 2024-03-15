import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/data/uploadToHive.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/screens/passwordDetailScreen.dart';
import 'package:cryptkey/screens/userPage.dart';
import 'package:cryptkey/utils/mobileAuth.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customDialog_widget.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> isFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirst') ?? true;
  }

  Future<void> upload() async {
    if (await isFirst() && await InternetConnectionChecker().hasConnection) {
      UploadToHive().uploadDataToHive(false);
    } else if (!await InternetConnectionChecker().hasConnection) {
      ToastMessage.showToast("No Internet Connection");
    }
  }

  void _canUse() async {
    if (!await isFirst()) {
      if (!await MobileAuth.authenticate("Verify to Enter")) {
        exit(0);
      }
    }
  }

  Future<void> updateWhileInternetConnection() async {
    if (!await isFirst() && await InternetConnectionChecker().hasConnection) {
      CloudFirestoreService().updateWhileInternetConnection();
    }
  }

  Future<void> fetchAndUpdateData() async {
    Provider.of<ScreenProvider>(context, listen: false).setPlatforms();
  }

  @override
  void initState() {
    _canUse();
    upload().then((_) async {
      // Wait for data upload to complete before fetching and updating data

      await UploadToHive().uploadDataToHive(true);

      fetchAndUpdateData(); // Fetch and update data after upload
    });

    // UploadToHive().uploadDataToHive();

    updateWhileInternetConnection();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScreenProvider>(context, listen: false).setPlatforms();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            backgroundColor: const Color.fromARGB(255, 2, 18, 46),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Hero(
                    tag: 'user',
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                          imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Image.asset('assets/icons/others.png'),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
            title: const Text(
              'CryptKey',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
              ),
            ),
          ),
          body: Consumer<ScreenProvider>(
            builder: (context, value, child) {
              return value.platformsList.isEmpty
                  ? Center(
                      child: Text(
                        "Tap on + icon to add data",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.platformsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: Card(
                            color: const Color.fromARGB(255, 2, 27, 70),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: value.numberOfAccounts(
                                        value.platformsList[index]) ==
                                    0
                                ? Container()
                                : ListTile(
                                    leading: Hero(
                                      tag: value.platformsList[index],
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: CustomIcon().customIcon(
                                            value.platformsList[index]
                                                .toLowerCase(),
                                            35),
                                      ),
                                    ),
                                    title: Text(
                                      value.platformsList[index],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23),
                                    ),
                                    subtitle: Text(
                                      "${value.numberOfAccounts(value.platformsList[index])} accounts",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    onTap: () async {
                                      // Boxes.getData().deleteAt(data[index].key);
                                      try {
                                        if (await MobileAuth.authenticate(
                                            "Verify to view accounts")) {
      
                                              if (!context.mounted) return;
                                                
                                              
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PasswordDetailsScreen(
                                                        platformName: value
                                                            .platformsList[index],
                                                        index: index,
                                                      )));
                                        } else {
                                          ToastMessage.showToast(
                                              "Authentication Failed");
                                        }
                                      } catch (error) {
                                        print(
                                            'Error navigating to password details screen: $error');
                                        // Handle error, for example show a snackbar
                                      }
                                      // Boxes.getData().clear();
                                    },
                                  ),
                          ),
                        );
                      });
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white.withAlpha(200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              try {
                // UploadToCloud().testData();
                // CloudFirestoreService().updateWhileInternetConnection();
      
                CustomDialog().showCustomDialog(context);
              } catch (e) {
                print("floating ${e}");
              }
            },
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 2, 18, 46),
            ),
          )),
    );
  }
}
