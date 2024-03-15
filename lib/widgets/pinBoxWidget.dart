import 'package:cryptkey/Firebase/checkAuthPin.dart';
import 'package:cryptkey/Firebase/dummyTestData.dart';
import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/screens/homePage_Screen.dart';
import 'package:cryptkey/utils/mobileAuth.dart';
import 'package:cryptkey/utils/toastMessage.dart';
import 'package:cryptkey/widgets/custinShakeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinBox extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool doesExist;
  const PinBox(
      {super.key,
      required this.controllers,
      required this.focusNodes,
      required this.doesExist});

  @override
  State<PinBox> createState() => _PinBoxState();
}

class _PinBoxState extends State<PinBox> {
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
        key: shakeKey,
        shakeOffset: 10.0,
        shakeCount: 3,
        child: Consumer<WidgetProvider>(
          builder: (context, provider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: widget.controllers[index],
                      focusNode: widget.focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                        filled: provider.isPinCorrect,
                        fillColor: Colors.white.withOpacity(0.1),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: provider.isPinCorrect
                                ? BorderSide.none
                                : BorderSide(color: Colors.red)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: provider.isPinCorrect
                                ? BorderSide.none
                                : BorderSide(color: Colors.red)),
                        counterText: '',
                      ),
                      onChanged: (value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (value.isNotEmpty && index < 3) {
                          widget.focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          widget.focusNodes[index - 1].requestFocus();
                        }
                        if (widget.controllers[1].text.isNotEmpty &&
                            widget.controllers[2].text.isNotEmpty &&
                            widget.controllers[3].text.isNotEmpty &&
                            widget.controllers[0].text.isNotEmpty) {
                          if (widget.doesExist) {
                            String value = widget.controllers[0].text +
                                widget.controllers[1].text +
                                widget.controllers[2].text +
                                widget.controllers[3].text;

                            bool isPinCorrect =
                                await CheckPin().checkPin(value);
                            provider.checkisPinCorrect(isPinCorrect);
                            if (provider.isPinCorrect) {
                              if (!context.mounted) {
                                return;
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (await MobileAuth.canAuthenticate()) {
                                if (await MobileAuth.authenticate(
                                    "Setup your biometrics")) {
                                  prefs.setString("pin", value);
                                  Future.delayed(Duration(milliseconds: 1000))
                                      .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage(),
                                            ),
                                          ));
                                } else {
                                  ToastMessage.showToast(
                                      "Unable to authenticate");
                                }
                              } else {
                                prefs.setString("pin", value);
                                Future.delayed(Duration(milliseconds: 1000))
                                    .then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        ));
                              }
                            }
                          } else {
                            String value = widget.controllers[0].text +
                                widget.controllers[1].text +
                                widget.controllers[2].text +
                                widget.controllers[3].text;
                            prefs.setString("pin", value);
                            await DummyTestData().dummyData(widget.doesExist);
                            if (!context.mounted) {
                              return;
                            }

                            FocusScope.of(context).requestFocus(FocusNode());

                            if (await MobileAuth.canAuthenticate()) {
                              if (await MobileAuth.authenticate(
                                  "Setup your biometrics")) {
                                prefs.setString("pin", value);
                                Future.delayed(Duration(milliseconds: 1000))
                                    .then((value) => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        ));
                              } else {
                                ToastMessage.showToast(
                                    "Unable to authenticate");
                              }
                            } else {
                              prefs.setString("pin", value);
                              Future.delayed(Duration(milliseconds: 1000))
                                  .then((value) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                      ));
                            }
                          }
                          if (!provider.isPinCorrect) {
                            shakeKey.currentState?.shake();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
