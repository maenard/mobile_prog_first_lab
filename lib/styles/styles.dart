import 'package:flutter/material.dart';

class Styles {
  static InputDecoration customInputDecoration(String labelText,
      {Icon? prefixIcon,
      IconData? suffixIcon,
      VoidCallback? suffixIconOnPress}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: (suffixIcon != null && suffixIconOnPress != null)
          ? IconButton(
              onPressed: suffixIconOnPress,
              icon: Icon(suffixIcon),
            )
          : null,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    );
  }

  static ButtonStyle primaryButton() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    );
  }
}
