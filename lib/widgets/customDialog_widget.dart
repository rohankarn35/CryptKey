import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
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
  void showCustomDialog(
    BuildContext context,
  ) async {
    final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    widgetProvider.setSliderValue(8);
    widgetProvider.controller.clear();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(child:
            Consumer<WidgetProvider>(builder: (context, widgetProvider, child) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 18, 46),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 2, 18, 46),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // controller: ScrollController(),
                  //   scrollDirection: Axis.vertical,
                  //   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  // shrinkWrap: true,
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
                    widgetProvider.isPlatformNameVisible
                        ? CustomTextField.buildTextField(
                            "Specify Platform (if others)", platformController)
                        : Container(),
                    widgetProvider.isPlatformNameVisible
                        ? const SizedBox(
                            height: 10,
                          )
                        : Container(),
                    CustomTextField.buildTextField(
                        "Username", usernameController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField.buildTextField(
                        "Password", widgetProvider.controller),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Slide to Generate Password",
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
                              widgetProvider.selectedValue = null;
                              widgetProvider.isPlatformNameVisible = false;

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            )),
                        TextButton(
                            onPressed: () {
                              if (widgetProvider.selectedValue != null &&
                                  usernameController.text.isNotEmpty) {
                                if (widgetProvider.selectedValue == "Others" &&
                                    platformController.text.isNotEmpty) {
                                  final data = PasswordManagerModel(
                                    platform: widgetProvider.selectedValue!,
                                    username: usernameController.text,
                                    password: widgetProvider.controller.text,
                                    platformName:
                                        platformController.text.trim(),
                                  );
                                  final box = Boxes.getData();
                                  box.add(data);
                                  data.save();

                                  Clipboard.setData(ClipboardData(
                                      text: widgetProvider.controller.text));
                                  Navigator.pop(context);
                                  ToastMessage.showToast(
                                      "Account added and Password Coped to Clipboard");
                                  widgetProvider.selectedValue = null;
                                  widgetProvider.isPlatformNameVisible = false;
                                } else if (widgetProvider.selectedValue !=
                                    "Others") {
                                  final data = PasswordManagerModel(
                                    platform: widgetProvider.selectedValue!,
                                    username: usernameController.text,
                                    password: widgetProvider.controller.text,
                                    platformName:
                                        platformController.text.trim(),
                                  );
                                  final box = Boxes.getData();
                                  box.add(data);
                                  data.save();
                                  Clipboard.setData(ClipboardData(
                                      text: widgetProvider.controller.text));
                                  Navigator.pop(context);
                                  ToastMessage.showToast("Account added");
                                  UploadToCloud().uploadToCloud();
                                  widgetProvider.selectedValue = null;
                                  widgetProvider.isPlatformNameVisible = false;
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

                              final screenProvider =
                                  Provider.of<ScreenProvider>(context,
                                      listen: false);
                              screenProvider.setPlatforms();
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
          );
        }));
      },
    );
  }
}
