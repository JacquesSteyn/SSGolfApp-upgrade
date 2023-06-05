import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:ss_golf/services/utilities_service.dart';

class DonutChart extends StatelessWidget {
  const DonutChart({this.value, this.total = 100});
  final double? value;
  final double total;

  @override
  Widget build(BuildContext context) {
    double checkedVal = (value != null && value! > total) ? 100 : total;

    return Container(
      height: Get.size.width * 0.28,
      child: SleekCircularSlider(
        min: 0,
        max: checkedVal,
        initialValue: value ?? 0,
        appearance: CircularSliderAppearance(
          startAngle: 270,
          angleRange: 360,
          spinnerMode: false,
          customColors: CustomSliderColors(
            trackColor: Colors.grey,
            dotColor: Colors.transparent,
            dynamicGradient: true,
            progressBarColor: Utilities.gradedColors(value),
          ),
          customWidths: CustomSliderWidths(trackWidth: 10),
        ),
        innerWidget: (val) => Center(
            child: Text(
          val.round().toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: Get.textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
