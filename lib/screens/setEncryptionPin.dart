import 'package:cryptkey/provider/widgetProvider.dart';
import 'package:cryptkey/widgets/pinBoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetEncryptionPin extends StatefulWidget {
  final bool doesExist;
  const SetEncryptionPin({super.key, required this.doesExist});

  @override
  State<SetEncryptionPin> createState() => _SetEncryptionPinState();
}

class _SetEncryptionPinState extends State<SetEncryptionPin> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    for (int i = 0; i < 4; i++) {
      if (i < 3) {
        controllers[i].addListener(() {
          if (controllers[i].text.length == 1) {
            focusNodes[i + 1].requestFocus();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.doesExist
                  ? "Enter your Encryption Pin"
                  : "Set your encryption pin",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            PinBox(
              controllers: controllers,
              focusNodes: focusNodes,
              doesExist: widget.doesExist,
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<WidgetProvider>(builder: (ctx, provider, child) {
              return !provider.isPinCorrect
                  ? const Text(
                      "Incorrect Pin Entered",
                      style: TextStyle(color: Colors.red),
                    )
                  : const Text("");
            })
          ],
        ),
      ),
    );
  }
}
