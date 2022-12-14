import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartInfo extends StatelessWidget {
  const ChartInfo({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: () => showDialog(
              context: context,
              builder: (_) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border:
                                  Border.all(color: Colors.white, width: 4)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                content,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Container(
                                  width: Get.width * 0.35,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text('GOT IT!',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
          icon: Icon(
            Icons.info_outline_rounded,
            color: Colors.blue,
            size: 35,
          ),
        ));
  }
}
