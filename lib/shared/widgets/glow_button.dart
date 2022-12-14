import 'package:flutter/material.dart';

class GlowButton extends StatelessWidget {
  const GlowButton(
      {Key? key, this.onPress, this.content, this.borderRadius = 10, this.width})
      : super(key: key);

  final Function? onPress;
  final Widget? content;
  final double borderRadius;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress!(),
      child: Container(
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 10.0,
              color: Color.fromARGB(218, 255, 255, 255),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: content,
        ),
      ),
    );
  }
}
