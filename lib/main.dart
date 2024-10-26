import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/components.dart';

void main() {
  final game = MyGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'PauseMenu' : _pauseMenuBuilder,
      },
    ),
  );
}


class MyGame extends FlameGame with TapDetector,HasKeyboardHandlerComponents,HasCollisionDetection {

  late PlayerComponent player;
  late TestingStage stage;

  @override
  Color backgroundColor() => const Color(0xffffffff);
  

  @override
  void onTap() {
    if (overlays.isActive('PauseMenu')) {
      overlays.remove('PauseMenu');
      resumeEngine();
    } else {
      overlays.add('PauseMenu');
      pauseEngine();
    }
  }

  
  @override
  Future<void>? onLoad() async{
    player = PlayerComponent();
    stage = TestingStage();
    stage.add(player);
    add(stage);
    add(ScreenHitbox());
    camera.worldBounds = Rect.fromPoints(Offset(-100,0),Offset(2000,2000));
    camera.followComponent(player);
  }
}



Widget _pauseMenuBuilder(BuildContext buildContext, MyGame game) {
  return GestureDetector(
    onTap: (){
      game.paused = false;
      game.overlays.remove('PauseMenu');
    },
    child: Container(
      color: Colors.black.withOpacity(.55),
      child: const Center(
        child: Text('Paused'),
      ),
    ),
  );
}