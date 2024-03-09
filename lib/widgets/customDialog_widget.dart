import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/utils/passwordGenerator.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/customDropDown_widget.dart';
import 'package:cryptkey/widgets/customSlider.dart';
import 'package:cryptkey/widgets/customTextField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CustomDialog {
  TextEditingController platformController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void showCustomDialog(
    BuildContext context,
  ) async {
    final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    widgetProvider.setSliderValue(8);
    platformselected = null;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 18, 46),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 2, 18, 46),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add New Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropDown().customDropDown(context),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField.buildTextField(
                        "Specify Platform (if others)", platformController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField.buildTextField(
                        "Username", usernameController),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Password Length",
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      textAlign: TextAlign.left,
                    ),
                    CustomSlider.customSlider(context),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            )),
                        TextButton(
                            onPressed: () {
                              if (platformselected != null &&
                                  usernameController.text.isNotEmpty) {
                                if (platformselected == "Others" &&
                                    platformController.text.isNotEmpty) {
                                  final data = PasswordManagerModel(
                                    platform: platformselected!,
                                    username: usernameController.text,
                                    password:
                                        PasswordGenerator.generatePassword(
                                            widgetProvider.sliderValue.toInt()),
                                    platformName: platformController.text,
                                  );
                                  final box = Boxes.getData();
                                  box.add(data);
                                  data.save();
                                  Clipboard.setData(ClipboardData(
                                      text: passwordController.text));
                                  Navigator.pop(context);
                                  ToastMessage.showToast(
                                      "Account added and Password Coped to Clipboard");
                                } else if (platformselected != "Others") {
                                  final data = PasswordManagerModel(
                                    platform: platformselected!,
                                    username: usernameController.text,
                                    password:
                                        PasswordGenerator.generatePassword(
                                            widgetProvider.sliderValue.toInt()),
                                    platformName: platformController.text,
                                  );
                                  final box = Boxes.getData();
                                  box.add(data);
                                  data.save();
                                  Clipboard.setData(ClipboardData(
                                      text: passwordController.text));
                                  Navigator.pop(context);
                                  ToastMessage.showToast(
                                      "Account added and Password Coped to Clipboard");
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please specify platform",
                                      fontSize: 20,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                }
                              }

                              // final data = PasswordManagerModel(
                              //     platform: platformController.text,
                              //     username: usernameController.text,
                              //     password: "password");

                              // // Save data to Hive
                              // final box = Boxes.getData();
                              // box.add(data);
                              // data.save();
                              // print(PasswordGenerator.generatePassword(10));
                              // Navigator.pop(context);
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showSelfDialog(BuildContext context) async {
    final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    widgetProvider.setSliderValue(8);
    platformselected = null;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 18, 46),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 2, 18, 46),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add Existing Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropDown().customDropDown(context),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField.buildTextField(
                        "Specify Platform (if others)", platformController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField.buildTextField(
                        "Username", usernameController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField.buildTextField(
                        "Password", passwordController),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            )),
                        TextButton(
                            onPressed: () {
                              if (platformselected != null &&
                                  usernameController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                if (platformselected == "Others" &&
                                    platformController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  final data = PasswordManagerModel(
                                    platform: platformselected!,
                                    username: usernameController.text,
                                    password: passwordController.text,
                                    platformName: platformController.text,
                                  );
                                  final box = Boxes.getData();
                                  box.add(data);
                                  data.save();
                                  Clipboard.setData(ClipboardData(
                                      text: passwordController.text));
                                  Navigator.pop(context);
                                  ToastMessage.showToast(
                                      "Account added and Password Coped to Clipboard");
                                } else if (platformselected != "Others") {
                                  final data = PasswordManagerModel(
                                    platform: platformselected!,
                                    username: usernameController.text,
                                    password: passwordController.text,
                                    platformName: platformController.text,
                                  );
                                  final box = Boxes.getData();
                                  box.add(data);
                                  data.save();
                                  Clipboard.setData(ClipboardData(
                                      text: passwordController.text));

                                  Navigator.pop(context);
                                  ToastMessage.showToast(
                                      "Account added and Password Coped to Clipboard");
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please specify platform",
                                      fontSize: 20,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                }
                              }

                              // final data = PasswordManagerModel(
                              //     platform: platformController.text,
                              //     username: usernameController.text,
                              //     password: "password");

                              // // Save data to Hive
                              // final box = Boxes.getData();
                              // box.add(data);
                              // data.save();
                              // print(PasswordGenerator.generatePassword(10));
                              // Navigator.pop(context);
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
