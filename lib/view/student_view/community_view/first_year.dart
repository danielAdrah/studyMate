// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../../theme.dart';

class FirstYear extends StatefulWidget {
  const FirstYear({super.key});

  @override
  State<FirstYear> createState() => _FirstYearState();
}

class _FirstYearState extends State<FirstYear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: TColor.background,
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            children: [
              
            ],),
        )
      ),
    );
  }
}