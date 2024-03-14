import 'package:cryptkey/widgets/customTextField_widget.dart';
import 'package:flutter/material.dart';

class PinBox extends StatefulWidget {
    final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  const PinBox({super.key, required this.controllers, required this.focusNodes});

  @override
  State<PinBox> createState() => _PinBoxState();
}

class _PinBoxState extends State<PinBox> {
 



  @override
  Widget build(BuildContext context) {
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
              controller: widget.controllers[index],
              focusNode: widget.focusNodes[index],
              keyboardType: TextInputType.number,
              maxLength: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  
                ),
              ),
              
              onChanged: (value) {
                if (value.isNotEmpty && index < 3) {
                  widget.focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  widget.focusNodes[index - 1].requestFocus();
                }
              },

            ),
          ),
        ),
      ),
    );
  }
}
