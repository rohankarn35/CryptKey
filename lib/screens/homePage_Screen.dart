import 'dart:io';

import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/screens/passwordDetailScreen.dart';
import 'package:cryptkey/screens/userPage.dart';
import 'package:cryptkey/utils/mobileAuth.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customDialog_widget.dart';
import 'package:cryptkey/widgets/customIcon.dart';
import 'package:cryptkey/widgets/editAccountDialog.dart';
import 'package:cryptkey/widgets/showConfirmationwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/adapters.dart';

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

  @override
  void initState() {
    // _canUse();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 18, 46),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 2, 18, 46),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:  (context) => UserPage()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Hero(
                tag: 'user',
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/icons/bank.png'),
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                                if (await MobileAuth.authenticate()) {
                                  EditAccountWidget().editAccountWidget(
                                    context,
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
                              },
                              backgroundColor: Colors.white,
                              label: 'Edit',
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              onPressed: (context) async {
                                if (await MobileAuth.authenticate()) {
                                  final bool result = await ShowConfirmationWidget
                                      .showConfirmationDialog(
                                          context,
                                          "Delete Account",
                                          "Do you want to delete it permanently?");
                                  if (result) {
                                    final box = Boxes.getData();
                                    box.deleteAt(index).then((value) =>
                                        ToastMessage.showToast(
                                            "Account Deleted"));
                                  } else {
                                    ToastMessage.showToast(
                                        "Authentication Failed");
                                  }
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
                            // if (await MobileAuth.authenticate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PasswordDetailsScreen(
                                          index: index,
                                        )));
                            // } else {
                            //   ToastMessage.showToast("Authentication Failed");
                            // }

                            // Boxes.getData().clear();
                          },
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: SpeedDial(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        buttonSize: Size(50, 50),
        animationCurve: Curves.bounceInOut,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 30.0),
        backgroundColor: Colors.white,
        overlayColor: Colors.black.withOpacity(0.6),
        childrenButtonSize: Size(70, 70),
        children: [
          SpeedDialChild(
            // child: Icon(Icons.add_circle_outline_rounded),
            backgroundColor: Colors.white,
            label: 'Add Existing Password',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
            onTap: () {
              // Handle add existing password action
              CustomDialog().showSelfDialog(context);
            },
          ),
          SpeedDialChild(
            // child: Icon(Icons.add),
            backgroundColor: Colors.white,
            label: 'Add New Password',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
            onTap: () {
              CustomDialog().showCustomDialog(context);
            },
          ),
        ],
        childPadding: EdgeInsets.all(10),
      ),
    );
  }
}
