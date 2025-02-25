import 'package:first_laboratory_exam/styles/styles.dart';
import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showVisibilityIcon;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;

  const OutlinedTextField({
    super.key,
    required this.controller,
    this.showVisibilityIcon = false,
    required this.labelText,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
  });

  @override
  State<OutlinedTextField> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.showVisibilityIcon ? _obscureText : false,
      style: const TextStyle(
        fontSize: 12,
      ),
      decoration: Styles.customInputDecoration(
        widget.labelText,
        suffixIcon: widget.showVisibilityIcon
            ? _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined
            : null,
        suffixIconOnPress: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
    );
  }
}
