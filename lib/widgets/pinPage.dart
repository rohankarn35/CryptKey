import 'package:cryptkey/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/custinShakeAnimation.dart';

// ignore: must_be_immutable
class PinScreen extends StatefulWidget {
  final Future<bool> Function(String)?
      onValidatePin; // Add callback for PIN validation
  final Widget toNavigate;
  bool isSetup;

  PinScreen({
    Key? key,
    required this.onValidatePin,
    required this.toNavigate,
    this.isSetup = false,
  }) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  List<Color> _borderColors = List.filled(4, Colors.white38);
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      _updateBorderColors();
    });
  }

  @override
  void dispose() {
    _pinController.removeListener(() {});
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
    if (_pinController.text.length == 4) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      bool isValid = widget.onValidatePin == null
          ? true
          : await widget.onValidatePin!(_pinController.text);

      setState(() {
        _isLoading = false; // Set loading state to false
      });

      if (isValid) {
        print('PIN Submitted: ${_pinController.text}');
        if (widget.onValidatePin == null || widget.isSetup) {
          navigateToPage(context, widget.toNavigate);
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => widget.toNavigate));
        }

        // Handle successful PIN submission logic
      } else {
        print('Invalid PIN');
        shakeKey.currentState?.shake();

        // Set all borders to red for error feedback
        setState(() {
          _borderColors = List.filled(4, Colors.red);
        });

        // After 1 second, reset border colors to reflect filled or unfilled state
        Timer(const Duration(seconds: 1), () {
          _updateBorderColors();
        });
      }
    } else {
      shakeKey.currentState?.shake();

      // Set all borders to red for error feedback
      setState(() {
        _borderColors = List.filled(4, Colors.red);
      });

      // After 1 second, reset border colors to reflect filled or unfilled state
      Timer(const Duration(seconds: 1), () {
        _updateBorderColors();
      });
    }
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
                pin: _pinController.text,
                pinCodeFieldIndex: index,
                theme: PinTheme(keysColor: Colors.white),
                fieldSize: screenWidth * 0.15,
                borderColor:
                    _borderColors[index], // Pass border color to PinCodeField
              );
            }),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        CustomKeyboard(
          controller: _pinController,
          maxLength: 4,
          onSubmit: _onSubmit,
          keySize: screenWidth * 0.18,
          isLoading: _isLoading, // Pass loading state to CustomKeyboard
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
  final bool isLoading; // Add loading state

  const CustomKeyboard({
    Key? key,
    required this.controller,
    required this.maxLength,
    required this.onSubmit,
    required this.keySize,
    required this.isLoading, // Initialize loading state
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
      onTap:
          isLoading ? null : () => _onKeyPressed(key), // Disable tap if loading
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
        child: key == 'Done' && isLoading
            ? CircularProgressIndicator(
                color: Colors.white,
              ) // Show loading indicator
            : FittedBox(
                child: Text(
                  key,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}

class PinCodeField extends StatelessWidget {
  final String pin;
  final int pinCodeFieldIndex;
  final PinTheme theme;
  final double fieldSize;
  final TextEditingController pinController;
  final Color borderColor; // New property for border color

  const PinCodeField({
    Key? key,
    required this.pin,
    required this.pinCodeFieldIndex,
    required this.theme,
    required this.fieldSize,
    required this.pinController,
    required this.borderColor, // Initialize border color
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
          border: Border.all(
              color: borderColor)), // Use border color passed as argument
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

class PinTheme {
  final Color keysColor;

  PinTheme({required this.keysColor});
}
