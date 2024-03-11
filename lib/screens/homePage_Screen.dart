import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/firebaseModels.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/data/uploadToHive.dart';
import 'package:cryptkey/screens/passwordDetailScreen.dart';
import 'package:cryptkey/screens/userPage.dart';
import 'package:cryptkey/utils/mobileAuth.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customDialog_widget.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:cryptkey/widgets/editAccountDialog.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _canUse() async {
    if (!await MobileAuth.authenticate()) {
      exit(0);
    }
  }

  Future<bool> isFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirst') ?? true;
  }

  upload() async {
    if (await isFirst()) {
      UploadToHive().uploadDataToHive();
    }
  }

  @override
  void initState() {
    upload();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 18, 46),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPage()));
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
        body: ValueListenableBuilder<Box<PasswordManagerModel>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, value, child) {
              var data = value.values.toList().cast<PasswordManagerModel>();
              return ListView.builder(
                  itemCount: data.length,
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
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  try {
                                    if (await MobileAuth.authenticate()) {
                                      EditAccountWidget().editAccountWidget(
                                        _context,
                                        index,
                                        data[index].platform,
                                        data[index].platformName,
                                        data[index].username,
                                        data[index].password,
                                      );
                                    } else {
                                      ToastMessage.showToast(
                                          "Authentication Failed");
                                    }
                                  } catch (error) {
                                    print('Error editing account: $error');
                                    // Handle error, for example show a snackbar
                                  }
                                },
                                backgroundColor: Colors.white,
                                label: 'Edit',
                                icon: Icons.edit,
                              ),
                              SlidableAction(
                                onPressed: (context) async {
                                  try {
                                    if (await MobileAuth.authenticate()) {
                                      print("delete pressed");

                                      final bool result =
                                          await ShowConfirmationWidget
                                              .showConfirmationDialog(
                                                  _context,
                                                  "Delete Account",
                                                  "Do you want to delete it permanently?");
                                      if (result) {
                                        final box = Boxes.getData();
                                        box.deleteAt(index).then((value) =>
                                            ToastMessage.showToast(
                                                "Account Deleted"));
                                        CloudFirestoreService().clearData();
                                        UploadToCloud().uploadToCloud();
                                      } else {
                                        ToastMessage.showToast(
                                            "Authentication Failed");
                                      }
                                    }
                                  } catch (error) {
                                    print('Error deleting account: $error');
                                    // Handle error, for example show a snackbar
                                  }
                                },
                                backgroundColor: Colors.red,
                                label: 'Delete',
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Hero(
                              tag: index,
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: CustomIcon().customIcon(
                                      data[index].platform.toLowerCase(), 35)),
                            ),
                            title: Text(
                              data[index].platformName.toString().isNotEmpty
                                  ? data[index].platformName.toString()
                                  : data[index].platform.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            ),
                            subtitle: Text(
                              data[index].username.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                            onTap: () async {
                              // Boxes.getData().deleteAt(data[index].key);
                              try {
                                if (await MobileAuth.authenticate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PasswordDetailsScreen(
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
                      ),
                    );
                  });
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: const Color.fromARGB(255, 2, 18, 46),
          ),
          backgroundColor: Colors.white.withAlpha(200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            // UploadToCloud().testData();
            UploadToCloud().uploadToCloud();
            CustomDialog().showCustomDialog(context);
          },
        ));
  }
}
