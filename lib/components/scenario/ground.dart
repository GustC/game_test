import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class Ground extends PositionComponent{
  Ground({
    super.size,
    super.position,
  });

  @override
  Future<void>? onLoad() {
    debugMode = true;
    debugColor = Color(0xff000000);
    anchor = Anchor.center;
    add(RectangleHitbox());
    return super.onLoad();
  }
}