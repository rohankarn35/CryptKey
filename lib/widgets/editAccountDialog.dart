import 'package:cryptkey/data/editHive.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/widgets/customSlider.dart';
import 'package:cryptkey/widgets/customTextField_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccountWidget {
  Widget editAccountWidget(BuildContext context, int index, String platform,
      String? platformName, String username, String password) {
    TextEditingController accountNameEditingController =
        TextEditingController(text: username);

    final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widgetProvider.setSliderValue(8);
      widgetProvider.controller.clear();
      widgetProvider.updatePassword(password);
    });

    return Dialog(
        insetAnimationCurve: Curves.easeInCubic,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
              child: SingleChildScrollView(child: Consumer<WidgetProvider>(
                builder: (context, value, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Edit Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField.buildTextField(
                        "Username",
                        accountNameEditingController,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField.buildTextField(
                        "Password",
                        value.controller,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Slide to Generate Password",
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        textAlign: TextAlign.left,
                      ),
                      CustomSlider.customSlider(context),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 20),
                          TextButton(
                            onPressed: () async {
                              if (accountNameEditingController
                                  .text.isNotEmpty) {
                                username = accountNameEditingController.text;
                              }
                              if (value.controller.text.isNotEmpty) {
                                password = value.controller.text;
                              }
                              final data = PasswordManagerModel(
                                platform: platform,
                                username: username,
                                password: password,
                                platformName: platformName,
                              );
                              await EditHive.editHive(data, index, context);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ))),
        ));
  }
}
