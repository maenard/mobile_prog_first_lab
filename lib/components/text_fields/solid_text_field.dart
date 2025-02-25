import 'package:flutter/material.dart';

class SolidTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool showVisibilityIcon;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;

  const SolidTextField({
    super.key,
    required this.controller,
    this.showVisibilityIcon = false,
    this.labelText = '',
    this.hintText = '',
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
  });

  @override
  State<SolidTextField> createState() => _SolidTextFieldState();
}

class _SolidTextFieldState extends State<SolidTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: const TextStyle(
        fontSize: 12,
      ),
      decoration: InputDecoration(
        filled: true,
        isDense: false,
        fillColor: Colors.grey[300],
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.bold),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 8, right: 4),
          child: Icon(Icons.search, size: 16),
        ),
        // prefixIconConstraints: const BoxConstraints(
        //   minWidth: 0,
        //   minHeight: 0,
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      ),
      // decoration: Styles.customInputDecoration(
      //   widget.labelText,
      //   suffixIcon: widget.showVisibilityIcon
      //       ? _obscureText
      //           ? Icons.visibility_off_outlined
      //           : Icons.visibility_outlined
      //       : null,
      //   suffixIconOnPress: () {
      //     setState(() {
      //       _obscureText = !_obscureText;
      //     });
      //   },
      // ),
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
    );
  }
}
