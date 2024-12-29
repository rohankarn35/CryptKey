import 'package:flutter/material.dart';

class CustomTextField {
  static Widget buildTextField(String label, TextEditingController? controller,
      String? Function(String?)? validator) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      cursorColor: Colors.white,
    );
  }
}
