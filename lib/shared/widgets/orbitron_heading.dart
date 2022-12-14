import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrbitronHeading extends StatelessWidget {
  const OrbitronHeading({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      style: GoogleFonts.orbitron(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: Get.textScaleFactor * 22,
              fontWeight: FontWeight.bold)),
    );
  }
}
