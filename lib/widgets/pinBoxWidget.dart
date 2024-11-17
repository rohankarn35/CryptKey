// import 'package:cryptkey/Firebase/dummyTestData.dart';
// import 'package:cryptkey/screens/biometricPage.dart';
// import 'package:cryptkey/utils/navigation.dart';
// import 'package:cryptkey/utils/toastMessage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';

// import '../Firebase/checkAuthPin.dart';
// import '../provider/widgetProvider.dart';
// import '../utils/mobileAuth.dart';
// import '../widgets/custinShakeAnimation.dart';

// class CustomPinScreen extends StatefulWidget {
//   final bool doesExist;
//   const CustomPinScreen({Key? key, required this.doesExist}) : super(key: key);

//   @override
//   State<CustomPinScreen> createState() => _CustomPinScreenState();
// }

// class _CustomPinScreenState extends State<CustomPinScreen> {
//   final TextEditingController _pinController = TextEditingController();
//   final shakeKey = GlobalKey<ShakeWidgetState>();
//   List<Color> _borderColors = List.filled(4, Colors.white38);

//   @override
//   void initState() {
//     super.initState();
//     _pinController.addListener(() {
//       _updateBorderColors();
//     });
//   }

//   @override
//   void dispose() {
//     _pinController.removeListener(() {});
//     _pinController.dispose();
//     super.dispose();
//   }

//   void _updateBorderColors() {
//     setState(() {
//       _borderColors = List.generate(4, (index) {
//         return _pinController.text.length > index
//             ? Colors.white
//             : Colors.white38;
//       });
//     });
//   }

//   void _onSubmit(WidgetProvider provider) async {
//     if (_pinController.text.length == 4) {
//       final pin = _pinController.text;
//       if (widget.doesExist) {
//         await _verifyPin(pin, provider);
//       } else {
//         await _setupNewPin(pin);
//       }
//       // Handle PIN submission logic
//     } else {
//       Fluttertoast.showToast(
//         msg: "Incomplete Pin",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       shakeKey.currentState?.shake();

//       // Set all borders to red for error feedback
//       setState(() {
//         _borderColors = List.filled(4, Colors.red);
//       });

//       // After 1 second, reset border colors to reflect filled or unfilled state
//       Timer(const Duration(seconds: 1), () {
//         _updateBorderColors();
//       });
//     }
//   }

//   Future<void> _verifyPin(String pin, WidgetProvider provider) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     bool isPinCorrect = await CheckPin().checkPin(pin);
//     provider.checkisPinCorrect(isPinCorrect);

//     if (isPinCorrect) {
//       prefs.setString("pin", pin);

//       if (await MobileAuth.canAuthenticate()) {
//         if (await MobileAuth.authenticate("Setup your biometrics")) {
//           navigateToPage(context, BiometricPage());
//         } else {
//           ToastMessage.showToast("Unable to authenticate");
//         }
//       } else {
//         Future.delayed(const Duration(milliseconds: 1000), () {
//           navigateToPage(context, BiometricPage());
//         });
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Incorrect Pin",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       shakeKey.currentState?.shake();

//       setState(() {
//         _borderColors = List.filled(4, Colors.red);
//       });

//       // After 1 second, reset border colors to reflect filled or unfilled state
//       Timer(const Duration(seconds: 1), () {
//         _updateBorderColors();
//       });
//     }
//   }

//   Future<void> _setupNewPin(String pin) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("pin", pin);
//     await DummyTestData().dummyData(widget.doesExist);

//     if (await MobileAuth.canAuthenticate()) {
//       if (await MobileAuth.authenticate("Setup your biometrics")) {
//         navigateToPage(context, BiometricPage());
//       } else {
//         ToastMessage.showToast("Unable to authenticate");
//       }
//     } else {
//       Future.delayed(const Duration(milliseconds: 1000), () {
//         navigateToPage(context, BiometricPage());
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ShakeWidget(
//           key: shakeKey,
//           shakeOffset: 10.0,
//           shakeCount: 3,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(4, (index) {
//               return PinCodeField(
//                 pinController: _pinController,
//                 pin: _pinController.text,
//                 pinCodeFieldIndex: index,
//                 theme: PinTheme(keysColor: Colors.white),
//                 fieldSize: screenWidth * 0.15,
//                 borderColor:
//                     _borderColors[index], // Pass border color to PinCodeField
//               );
//             }),
//           ),
//         ),
//         SizedBox(height: screenHeight * 0.05),
//         Consumer<WidgetProvider>(
//           builder: (context, value, child) {
//             return CustomKeyboard(
//               controller: _pinController,
//               maxLength: 4,
//               onSubmit: () => _onSubmit(value),
//               keySize: screenWidth * 0.18,
//             );
//           },
//         )
//       ],
//     );
//   }
// }

// class CustomKeyboard extends StatelessWidget {
//   final TextEditingController controller;
//   final int maxLength;
//   final VoidCallback onSubmit;
//   final double keySize;

//   const CustomKeyboard({
//     Key? key,
//     required this.controller,
//     required this.maxLength,
//     required this.onSubmit,
//     required this.keySize,
//   }) : super(key: key);

//   void _onKeyPressed(String key) {
//     if (key == 'DEL') {
//       if (controller.text.isNotEmpty) {
//         controller.text =
//             controller.text.substring(0, controller.text.length - 1);
//       }
//     } else if (key == 'Done') {
//       onSubmit();
//     } else if (controller.text.length < maxLength) {
//       controller.text += key;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Wrap(
//           spacing: 40,
//           runSpacing: 20,
//           alignment: WrapAlignment.center,
//           children: [
//             for (var i = 1; i <= 9; i++) _buildKey(i.toString()),
//             _buildKey('DEL'),
//             _buildKey('0'),
//             _buildKey('Done'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildKey(String key) {
//     return InkWell(
//       onTap: () => _onKeyPressed(key),
//       child: Container(
//         margin: EdgeInsets.all(0),
//         alignment: Alignment.center,
//         width: key == "Done" ? keySize * 1.15 : keySize,
//         height: keySize,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(0),
//         ),
//         child: FittedBox(
//           child: Text(
//             key,
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PinCodeField extends StatelessWidget {
//   final String pin;
//   final int pinCodeFieldIndex;
//   final PinTheme theme;
//   final double fieldSize;
//   final TextEditingController pinController;
//   final Color borderColor; // New property for border color

//   const PinCodeField({
//     Key? key,
//     required this.pin,
//     required this.pinCodeFieldIndex,
//     required this.theme,
//     required this.fieldSize,
//     required this.pinController,
//     required this.borderColor, // Initialize border color
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final pinText = pinController.text;
//     final isDigitEntered = pinText.length > pinCodeFieldIndex;
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       height: fieldSize,
//       width: fieldSize,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: borderColor)), // Use border color passed as argument
//       child: isDigitEntered
//           ? Center(
//               child: Text(
//                 pinText[pinCodeFieldIndex],
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           : const SizedBox(),
//     );
//   }
// }

// class PinTheme {
//   final Color keysColor;

//   PinTheme({required this.keysColor});
// }

import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/custinShakeAnimation.dart';

class CustomPinWidget extends StatefulWidget {
  final TextEditingController pinController;
  final int pinLength;
  final VoidCallback onSubmit;

  const CustomPinWidget({
    Key? key,
    required this.pinController,
    required this.pinLength,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CustomPinWidget> createState() => _CustomPinWidgetState();
}

class _CustomPinWidgetState extends State<CustomPinWidget> {
  final GlobalKey<ShakeWidgetState> shakeKey = GlobalKey<ShakeWidgetState>();
  List<Color> _borderColors = [];

  @override
  void initState() {
    super.initState();
    _borderColors = List.filled(widget.pinLength, Colors.white38);
    widget.pinController.addListener(_updateBorderColors);
  }

  @override
  void dispose() {
    widget.pinController.removeListener(_updateBorderColors);
    super.dispose();
  }

  void _updateBorderColors() {
    setState(() {
      _borderColors = List.generate(widget.pinLength, (index) {
        return widget.pinController.text.length > index
            ? Colors.green
            : Colors.white38;
      });
    });
  }

  void _onSubmit() {
    if (widget.pinController.text.length == widget.pinLength) {
      widget.onSubmit();
    } else {
      shakeWithError();
    }
  }

  /// This method triggers a shake animation and sets borders to red temporarily.
  void shakeWithError() {
    shakeKey.currentState?.shake();

    setState(() {
      _borderColors = List.filled(widget.pinLength, Colors.red);
    });

    Timer(const Duration(seconds: 1), () {
      _updateBorderColors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShakeWidget(
          key: shakeKey,
          shakeOffset: 10.0,
          shakeCount: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.pinLength, (index) {
              return PinCodeField(
                pinController: widget.pinController,
                pin: widget.pinController.text,
                pinCodeFieldIndex: index,
                fieldSize: screenWidth * 0.15,
                borderColor: _borderColors[index],
              );
            }),
          ),
        ),
        SizedBox(height: 20),
        CustomKeyboard(
          controller: widget.pinController,
          maxLength: widget.pinLength,
          onSubmit: _onSubmit,
          keySize: screenWidth * 0.18,
        ),
      ],
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final VoidCallback onSubmit;
  final double keySize;

  const CustomKeyboard({
    Key? key,
    required this.controller,
    required this.maxLength,
    required this.onSubmit,
    required this.keySize,
  }) : super(key: key);

  void _onKeyPressed(String key) {
    if (key == 'DEL') {
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      }
    } else if (key == 'Done') {
      onSubmit();
    } else if (controller.text.length < maxLength) {
      controller.text += key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Wrap(
          spacing: 40,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 1; i <= 9; i++) _buildKey(i.toString()),
            _buildKey('DEL'),
            _buildKey('0'),
            _buildKey('Done'),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String key) {
    return InkWell(
      onTap: () => _onKeyPressed(key),
      child: Container(
        margin: EdgeInsets.all(0),
        alignment: Alignment.center,
        width: key == "Done" ? keySize * 1.15 : keySize,
        height: keySize,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(0),
        ),
        child: FittedBox(
          child: Text(
            key,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class PinCodeField extends StatelessWidget {
  final String pin;
  final int pinCodeFieldIndex;
  final double fieldSize;
  final TextEditingController pinController;
  final Color borderColor;

  const PinCodeField({
    Key? key,
    required this.pin,
    required this.pinCodeFieldIndex,
    required this.fieldSize,
    required this.pinController,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pinText = pinController.text;
    final isDigitEntered = pinText.length > pinCodeFieldIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: fieldSize,
      width: fieldSize,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor)),
      child: isDigitEntered
          ? Center(
              child: Text(
                pinText[pinCodeFieldIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
