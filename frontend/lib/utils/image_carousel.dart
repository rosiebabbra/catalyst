import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  double _xOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < widget.images.length; i++)
          Positioned(
            left: i * MediaQuery.of(context).size.width + _xOffset,
            child: Image.asset(
              widget.images[i],
              width: MediaQuery.of(context).size.width * 0.85,
            ),
          ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _xOffset += details.delta.dx;
            });
          },
          onHorizontalDragEnd: (details) {
            if (_xOffset <
                -(widget.images.length - 1) *
                    MediaQuery.of(context).size.width) {
              setState(() {
                _xOffset = -(widget.images.length - 1) *
                    MediaQuery.of(context).size.width;
              });
            } else if (_xOffset > 0) {
              setState(() {
                _xOffset = 0;
              });
            }
          },
          child: Container(
            width: double.infinity,
            height: 150,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
