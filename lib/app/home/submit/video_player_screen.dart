import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  VideoPlayerScreen({this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl.isNotEmpty) {
      BetterPlayerDataSource betterPlayerDataSource =
          BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.videoUrl);
      _controller = BetterPlayerController(BetterPlayerConfiguration(),
          betterPlayerDataSource: betterPlayerDataSource);
    }
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.orange,
          // borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF28C399),
          ), // Colors.white),
          // borderSide: Border(color: Colors.white),
        ),
        child: widget.videoUrl.isNotEmpty
            ? BetterPlayer(
                controller: _controller,
              )
            : Center(
                child: Text(
                  'No video available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
