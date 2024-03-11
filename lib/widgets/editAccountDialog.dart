import 'package:cryptkey/data/boxes.dart';
import 'package:cryptkey/data/passwordManagerModel.dart';
import 'package:cryptkey/data/uploadToCloud.dart';
import 'package:cryptkey/provider/screenProvider.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/utils/passwordGenerator.dart';
import 'package:cryptkey/widgets/customSlider.dart';
import 'package:cryptkey/widgets/customTextField_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccountWidget {
  void editAccountWidget(BuildContext context, int index, String platform,
      String? platformName, String username, String password) async {
    TextEditingController _accountNameEditingController =
        TextEditingController(text: username);

    TextEditingController _passwordEditingController = TextEditingController();
    final widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    widgetProvider.setSliderValue(8);
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                    child:
                        SingleChildScrollView(child: Consumer<WidgetProvider>(
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
                                "Username", _accountNameEditingController),
                            const SizedBox(height: 10),
                            CustomTextField.buildTextField(
                                "Password", _passwordEditingController),
                            const SizedBox(height: 10),
                            Text(
                              "Generate Password Instead",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6)),
                              textAlign: TextAlign.left,
                            ),
                            CustomSlider.customSlider(context),
                            TextButton(
                                onPressed: () {
                                  widgetProvider.updatePassword(
                                      PasswordGenerator.generatePassword(
                                          value.sliderValue.toInt()));
                                  _passwordEditingController.text =
                                      value.newPassword!;
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Generate Password",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 2, 18, 46),
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 20),
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
                                  onPressed: () {
                                    if (_accountNameEditingController
                                        .text.isNotEmpty) {
                                      username =
                                          _accountNameEditingController.text;
                                    }
                                    if (_passwordEditingController
                                        .text.isNotEmpty) {
                                      password =
                                          _passwordEditingController.text;
                                    }
                                    final data = PasswordManagerModel(
                                      platform: platform,
                                      username: username,
                                      password: password,
                                      platformName: platformName,
                                    );

                                    final box = Boxes.getData();
                                    box.putAt(index, data);
                                    data.save();
                                    Provider.of<ScreenProvider>(context,
                                            listen: false)
                                        .getAllFields(index);
                                    UploadToCloud().uploadToCloud();

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
                    )),
                  )));
        });
  }
}
