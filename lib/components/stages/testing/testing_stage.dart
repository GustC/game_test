import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_test/components/components.dart';
import 'package:tiled/tiled.dart';


class TestingStage extends Component
  with CollisionCallbacks{
  
  @override
  Future<void>? onLoad() async{
    add(Ground(
      size: Vector2(300, 50),
      position: Vector2(150, 550),
    ));
    add(Ground(
      size: Vector2(150, 200),
      position: Vector2(400, 500),
    ));
    add(Ground(
      size: Vector2(100, 100),
      position: Vector2(650, 525),
    ));
    add(Ground(
      size: Vector2(100, 650),
      position: Vector2(930, 525),
    ));
    add(Ground(
      size: Vector2(300, 50),
      position: Vector2(755, 1250),
    ));
  }
  
}