import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/ui/person/widgets/person_register.dart';
import 'package:video_player/video_player.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {

  @override
  Widget build(BuildContext context) {
    return Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: MediaQuery.sizeOf(context).height,
                                  color: Colors.white,
                                    child: Center(
                                    child: LoopVideoWidget(),
                                    ),
                                  );
  }
}


class LoopVideoWidget extends StatefulWidget {
  final String assetPath;
  const LoopVideoWidget({this.assetPath = 'images/loop.mp4', super.key});

  @override
  State<LoopVideoWidget> createState() => _LoopVideoWidgetState();
}

class _LoopVideoWidgetState extends State<LoopVideoWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.5,
      height: MediaQuery.sizeOf(context).height * 0.4,
      color: Color(0xfffffeff),
      child: Center(
        child: _initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
                
              )
            : Container(),
      ),
    );
  }
}