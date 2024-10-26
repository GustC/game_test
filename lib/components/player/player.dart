import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../../data/data.dart';
import '../../sprite-data/sprite_data.dart';
import '../components.dart';

class PlayerComponent extends SpriteAnimationComponent
  with KeyboardHandler,CollisionCallbacks{
  PlayerComponent();  

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runningAnimation;
  late SpriteAnimation jumpUpSprite;
  late SpriteAnimation jumpFallSprite;
  late SpriteAnimation attackAnimation;
  final Vector2 _playerVelocity = Vector2.zero();
  final double _speed = 200;
  final double _jumpSpeed = 600;
  final double _gravity = 10;
  int _hAxisInput = 0;
  bool idle = true;
  bool _onGround = false;
  bool _jumping = false;
  bool _attacking = false;

  @override
  Future<void>? onLoad() async {
    var sprites = idleSprites.map((i) => Sprite.load(i));
    idleAnimation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: .12,
      loop: false
    );        
    sprites = runningSprites.map((i) => Sprite.load(i));
    runningAnimation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: .1,
    );
    sprites = attackSprites.map((i) => Sprite.load(i));
    attackAnimation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: .1,
    );
    jumpUpSprite = SpriteAnimation.variableSpriteList(
      [
        await Sprite.load(jumpUp),
      ], 
      stepTimes: [.1],
      loop: false,
    );
    jumpFallSprite = SpriteAnimation.variableSpriteList(
      [
        await Sprite.load(jumpFall),
      ], 
      stepTimes: [.1],
      loop: false,
    );
    animation = idleAnimation;
    size = Vector2.all(128.0);
    idle = true;
    anchor = Anchor.center;
    position = Vector2(100, 300);
    debugMode = true;
    animation!.onComplete = onCompleteAnimationListener;
    
    add(CircleHitbox());
  }

  void onCompleteAnimationListener() {
    if(idle){
      Future.delayed(Duration(seconds: 2),(){
        if(idle){
          animation!.reset();
          update(0);
        }
      });
    }
  }

  void _changeIdle(bool status){
    idle = status;
    if(status){
      if(_attacking){
        animation = attackAnimation;
      } else {
        animation = idleAnimation;
      }
    } else {
      animation = runningAnimation;      
    }
  }

  void _movePlayer(PlayerMoveDirection direction){
    switch (direction) {
      case PlayerMoveDirection.left:
        if(!isFlippedHorizontally){
          flipHorizontally();
        }
        _hAxisInput = -1;
        break;
      case PlayerMoveDirection.right:        
        if(isFlippedHorizontally){
          flipHorizontally();
        }
        _hAxisInput = 1;
        break;
      case PlayerMoveDirection.up:
        _jumping = true;
        break;
      case PlayerMoveDirection.bottom:
        break;
      default:
        break;
    }
  }


  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ){
    // final isKeyDown = event is RawKeyDownEvent;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
        _movePlayer(PlayerMoveDirection.left);
      } else {
        _movePlayer(PlayerMoveDirection.right);
      }
    } else {
      _hAxisInput = 0;
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      _movePlayer(PlayerMoveDirection.up);
    } 
    _attacking = keysPressed.contains(LogicalKeyboardKey.keyZ);
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Ground){
      if(intersectionPoints.length == 2){
        final mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1))/2;
        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();
        if(Vector2(0, -1).dot(collisionNormal) > .9){
          _onGround = true;
        }
        position += collisionNormal.scaled(separationDistance);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    _changeIdle(_hAxisInput == 0);
    _playerVelocity.x = _hAxisInput * _speed;
    _playerVelocity.y += _gravity;

    if(_jumping){
      if(_onGround){
        _playerVelocity.y = -_jumpSpeed;
        _onGround = false; 
      }
      _jumping = false;
    }

    _playerVelocity.y = _playerVelocity.y.clamp(-_jumpSpeed, _jumpSpeed);

    if(_playerVelocity.y.isNegative){
      animation = jumpUpSprite;
    } else if(!_onGround){
      animation = jumpFallSprite;
    } 

    position += _playerVelocity * dt;
    super.update(dt);
  }
}