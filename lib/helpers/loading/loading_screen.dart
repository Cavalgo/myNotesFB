import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreenController? myController;
  //Singletone
  LoadingScreen._singletone();
  static final myLoadingScreen = LoadingScreen._singletone();
  //Singletone

  void hide() {
    myController?.close();
    myController = null;
  }

  void show({
    required BuildContext context,
    required text,
  }) {
    if (myController?.update(text) ?? false) {
      return;
    } else {
      myController = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textSream = StreamController<String>();
    textSream.add(text);
    OverlayState state = Overlay.of(context);
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    OverlayEntry overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: textSream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textSream.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textSream.add(text);
        return true;
      },
    );
  }
}
