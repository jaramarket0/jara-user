import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon, this.onChanged,
    this.prefixIcon,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        fillColor: Color(0xffF5F5F5),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color:Colors.amber
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Color(0xffD9D9D9)
          )
        ),
        errorText: errorText,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[300]),
        suffixIcon: suffixIcon,
        prefix: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}