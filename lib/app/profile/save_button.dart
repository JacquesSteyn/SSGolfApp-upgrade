import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSaved;
  SaveButton({this.onPressed, this.isLoading, this.isSaved});

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  // Color _startingColor = Colors.blue;
  // Color _endingColor = Colors.green;

  AnimationController _controller;
  // Animation<Color> _appearAnimation;
  Animation<Color> _successAnimation;
  // Animation<Color> _disappearAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    // _appearAnimation =
    //     ColorTween(begin: Colors.transparent, end: Colors.blue).animate(_controller);
    _successAnimation = ColorTween(
            begin: Get.theme.backgroundColor.withOpacity(0.7),
            end: Colors.green)
        .animate(_controller);
    // _disappearAnimation =
    //     ColorTween(begin: Colors.green, end: Colors.transparent).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSaved) {
      _controller.forward();
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Colors.grey[300],
                  width: 1,
                ),
              ),
              primary: _successAnimation.value,
              elevation: 10,
            ),
            onPressed: () {
              // _controller.forward();
              widget.onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 4, 1, 4),
              child: widget.isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.grey[100],
                    )
                  : widget.isSaved
                      ? Column(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.grey[100],
                            ),
                            Text(
                              'saved',
                              style: TextStyle(
                                color: Colors.grey[100],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Icon(Icons.save, color: Colors.grey[100]),
                            Text(
                              'save',
                              style: TextStyle(color: Colors.grey[100]),
                            ),
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }
}
