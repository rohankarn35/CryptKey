import 'package:cryptkey/widgets/customButton_widget.dart';
import 'package:cryptkey/widgets/customTextField_widget.dart';
import 'package:cryptkey/widgets/pinBoxWidget.dart';
import 'package:flutter/material.dart';

class SetEncryptionPin extends StatefulWidget {
  const SetEncryptionPin({super.key});

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
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "Enter your encryption pin",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 40,
                ),
                PinBox(
                  controllers: controllers,
                  focusNodes: focusNodes,
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton().customButton("Done", () { }, context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
