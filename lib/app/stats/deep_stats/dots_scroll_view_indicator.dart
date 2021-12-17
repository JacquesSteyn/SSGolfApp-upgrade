import 'package:flutter/material.dart';
import 'dart:math';

class DotsScrollViewIndicator extends AnimatedWidget {
  DotsScrollViewIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;
  // The increase in the size of the selected dot
  static const double _kMaxZoom = 5.0;
  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          // color: index == controller.page ? Colors.white : Colors.grey,
          color: Colors.white.withOpacity(0.2 * zoom), //(max(1.0, 0.2 * zoom)),
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}
