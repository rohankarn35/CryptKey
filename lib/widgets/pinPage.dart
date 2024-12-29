import 'package:cryptkey/Firebase/checkAuthPin.dart';
import 'package:cryptkey/Firebase/cloudstore.dart';
import 'package:cryptkey/Firebase/dummyTestData.dart';
import 'package:cryptkey/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../screens/biometricPage.dart';
import '../widgets/custinShakeAnimation.dart';

class PinScreen extends StatefulWidget {
  final bool doesExist;
  PinScreen({
    Key? key,
    required this.doesExist,
  }) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  List<Color> _borderColors = List.filled(4, Colors.white38);
  bool _isLoading = false;

  @override
  void initState() {
    print(widget.doesExist);
    super.initState();
    _pinController.addListener(_updateBorderColors);
  }

  @override
  void dispose() {
    _pinController.removeListener(_updateBorderColors);
    _pinController.dispose();
    super.dispose();
  }

  void _updateBorderColors() {
    setState(() {
      _borderColors = List.generate(4, (index) {
        return _pinController.text.length > index
            ? Colors.green
            : Colors.white38;
      });
    });
  }

  Future<void> _onSubmit() async {
    bool isPinCorrect = false;
    if (_pinController.text.length == 4) {
      final String _pin = _pinController.text;
      setState(() => _isLoading = true);
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("pin", _pin);

        if (widget.doesExist) {
          isPinCorrect = await CheckPin().checkPin(_pin);
        } else {
          await DummyTestData().dummyData(widget.doesExist);
          await CloudFirestoreService().addUserToDatabase();
          isPinCorrect = true;
        }

        if (isPinCorrect) {
          navigateToPage(context, BiometricPage());
        } else {
          _showInvalidPinFeedback();
        }
      } catch (e) {
        print("something went wrong in try catch ${e.toString()}");

        _showInvalidPinFeedback();
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      _showInvalidPinFeedback();
    }
  }

  void _showInvalidPinFeedback() {
    shakeKey.currentState?.shake();
    setState(() => _borderColors = List.filled(4, Colors.red));
    Timer(const Duration(seconds: 1), _updateBorderColors);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
            children: List.generate(4, (index) {
              return PinCodeField(
                pinController: _pinController,
                pinCodeFieldIndex: index,
                fieldSize: screenWidth * 0.15,
                borderColor: _borderColors[index],
              );
            }),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        CustomKeyboard(
          controller: _pinController,
          maxLength: 4,
          onSubmit: () async {
            await _onSubmit();
          },
          keySize: screenWidth * 0.18,
          isLoading: _isLoading,
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
  final bool isLoading;

  const CustomKeyboard({
    Key? key,
    required this.controller,
    required this.maxLength,
    required this.onSubmit,
    required this.keySize,
    required this.isLoading,
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
      onTap: isLoading ? null : () => _onKeyPressed(key),
      child: Container(
        alignment: Alignment.center,
        width: key == "Done" ? keySize * 1.15 : keySize,
        height: keySize,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black),
        ),
        child: key == 'Done' && isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : FittedBox(
                child: Text(
                  key,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}

class PinCodeField extends StatelessWidget {
  final int pinCodeFieldIndex;
  final double fieldSize;
  final TextEditingController pinController;
  final Color borderColor;

  const PinCodeField({
    Key? key,
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
        border: Border.all(color: borderColor),
      ),
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
