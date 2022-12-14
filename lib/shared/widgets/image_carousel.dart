import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({Key? key, this.images}) : super(key: key);

  final List<String?>? images;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int currentImageIndex = 0;

  imageIndicator(List<String?> newList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: newList.map((url) {
        int id = newList.indexOf(url);
        return Container(
          margin: EdgeInsets.only(bottom: 10, left: 5),
          decoration: BoxDecoration(
              color: id == currentImageIndex
                  ? Color.fromARGB(158, 0, 0, 0)
                  : Color.fromARGB(128, 96, 95, 95),
              borderRadius: BorderRadius.circular(5)),
          height: 4,
          width: 50,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String?> newList = [];

    widget.images!.forEach(
      (image) {
        if (image!.isNotEmpty) newList.add(image);
      },
    );

    return Stack(
      children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              currentImageIndex = value;
            });
          },
          children: newList.map((url) {
            return Image.network(
              url!,
              fit: BoxFit.cover,
            );
          }).toList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: imageIndicator(newList),
        ),
      ],
    );
  }
}
