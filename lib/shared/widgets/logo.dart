import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? dimension;
  final Alignment alignment;
  Logo({this.dimension, this.alignment = Alignment.topCenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/smart_stats_logo_inverse.png'),
          fit: BoxFit.fitWidth,
          alignment: alignment,
        ),
      ),
    );
  }
}
