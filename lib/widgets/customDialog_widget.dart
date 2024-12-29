import 'package:cryptkey/data/addToHive.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/widgets/customDropDown_widget.dart';
import 'package:cryptkey/widgets/customSlider.dart';
import 'package:cryptkey/widgets/customTextField_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDialog {
  TextEditingController platformController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  void showCustomDialog(
    BuildContext context,
  ) async {
    final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    final screenProvider = Provider.of<ScreenProvider>(context, listen: false);
    widgetProvider.setSliderValue(8);
    widgetProvider.controller.clear();
    final _formKey = GlobalKey<FormState>();

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
                child: Form(
                  key: _formKey,
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
                      widgetProvider.isPlatformNameVisible
                          ? CustomTextField.buildTextField(
                              "Specify Platform (if others)",
                              platformController,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter platform';
                                }
                                return null;
                              },
                            )
                          : Container(),
                      widgetProvider.isPlatformNameVisible
                          ? const SizedBox(
                              height: 10,
                            )
                          : Container(),
                      CustomTextField.buildTextField(
                        "Username",
                        usernameController,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField.buildTextField(
                        "Password",
                        widgetProvider.controller,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (widgetProvider.selectedValue != null &&
                                      usernameController.text.isNotEmpty) {
                                    if (widgetProvider.selectedValue ==
                                            "Others" &&
                                        platformController.text.isNotEmpty) {
                                      bool isAdded =
                                          await AddDataToHive.addData(
                                        platformController.text.trim(),
                                        widgetProvider.selectedValue!,
                                        usernameController.text,
                                        widgetProvider.controller.text,
                                      );
                                      if (isAdded) {
                                        widgetProvider.selectedValue = null;
                                        widgetProvider.isPlatformNameVisible =
                                            false;
                                        Navigator.pop(context);
                                      }
                                    } else if (widgetProvider.selectedValue !=
                                        "Others") {
                                      bool isAdded =
                                          await AddDataToHive.addData(
                                        platformController.text.trim(),
                                        widgetProvider.selectedValue!,
                                        usernameController.text,
                                        widgetProvider.controller.text,
                                      );
                                      if (isAdded) {
                                        Navigator.pop(context);
                                        widgetProvider.selectedValue = null;
                                        widgetProvider.isPlatformNameVisible =
                                            false;
                                      }
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
                                  screenProvider.setPlatforms();
                                  await UploadToCloud().uploadToCloud();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool("willBeUpdated", true);
                                }
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
        }));
      },
    );
  }
}
