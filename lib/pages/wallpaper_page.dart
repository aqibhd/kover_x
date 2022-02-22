import 'package:flutter/material.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:kover_x/const_file.dart';
import 'package:kover_x/widgets/close_btn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class WallpaperPage extends StatefulWidget {
  Map source;
  WallpaperPage({Key? key, required this.source}) : super(key: key);

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  final FaderController _controller = FaderController();
  final FaderController _controller1 = FaderController();

  ScreenshotController screenshotController = ScreenshotController();
  bool pressed = false;
  bool result = false;
  bool test = false;
  String code(String code) {
    return '0xff' + code.substring(1);
  }

  Future<void> setWall() async {
    String fileName = widget.source['alt'];

    int location = WallpaperManager
        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    final directory = (await getApplicationDocumentsDirectory())
        .path; //from path_provide package
    String path = directory;
    await screenshotController.captureAndSave(
        path, //set path where screenshot will be saved
        fileName: fileName);
    String newPath = path + "/$fileName";
    result = await WallpaperManager.setWallpaperFromFile(newPath, location);
    if (result) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wallpaper set")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              color: Color(int.parse(code(widget.source['avg_color']))),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                enableFeedback: false,
                onTap: () {
                  test = !test;
                  if (test) {
                    _controller.fadeOut();
                    _controller1.fadeOut();
                  } else {
                    _controller.fadeIn();
                    _controller1.fadeIn();
                  }
                },
                child: Screenshot(
                  controller: screenshotController,
                  child: InteractiveViewer(
                    alignPanAxis: true,
                    constrained: false,
                    scaleEnabled: true,
                    minScale: .9,
                    maxScale: 1.5,
                    child: FadeInImage.memoryNetwork(
                      image: widget.source['src']['large2x'],
                      placeholder: kTransparentImage,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
              ),
            ),
            Fader(
              controller: _controller,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Opacity(
                        opacity: .25,
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                      ),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () {
                              pressed = true;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: CloseBtn(
                              clicked: pressed,
                              tapBackgroundColor:
                                  const Color.fromARGB(30, 36, 36, 36),
                              borderColor: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              widget.source['alt'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              height: 36,
                              width: 36,
                            ))
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Fader(
                controller: _controller1,
                duration: const Duration(milliseconds: 300),
                child: InkWell(
                  onTap: () => {
                    setWall(),
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    child: Text("Apply",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.7,
                            color: Colors.white)),
                    color: secondary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
