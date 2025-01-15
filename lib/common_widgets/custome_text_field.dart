// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final void Function()? onTap;
  IconData? suffixIcon;
  final bool secure;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  CustomTextForm({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    this.validator,
    this.suffixIcon,
    required this.secure,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      obscureText: secure,
      validator: validator,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hinttext,
        suffixIcon: InkWell(
            onTap: onTap,
            child: Icon(
              suffixIcon,
            )),
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide(
              color: Color.fromARGB(31, 179, 206, 231),
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(
            color: Color.fromARGB(31, 179, 206, 231),
          ),
        ),
      ),
    );
  }
}
