/*
d8888b. db       .d8b.   .o88b. db   dD   db      d888888b db    db d88888b .d8888.   .88b  d88.  .d8b.  d888888b d888888b d88888b d8888b.
88  `8D 88      d8' `8b d8P  Y8 88 ,8P'   88        `88'   88    88 88'     88'  YP   88'YbdP`88 d8' `8b `~~88~~' `~~88~~' 88'     88  `8D
88oooY' 88      88ooo88 8P      88,8P     88         88    Y8    8P 88ooooo `8bo.     88  88  88 88ooo88    88       88    88ooooo 88oobY'
88~~~b. 88      88~~~88 8b      88`8b     88         88    `8b  d8' 88~~~~~   `Y8b.   88  88  88 88~~~88    88       88    88~~~~~ 88`8b
88   8D 88booo. 88   88 Y8b  d8 88 `88.   88booo.   .88.    `8bd8'  88.     db   8D   88  88  88 88   88    88       88    88.     88 `88.
Y8888P' Y88888P YP   YP  `Y88P' YP   YD   Y88888P Y888888P    YP    Y88888P `8888Y'   YP  YP  YP YP   YP    YP       YP    Y88888P 88   YD*/

import 'dart:math';

import 'package:engen/main/engineGate.dart';
import 'package:engen/main/etc.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Snake extends MatrixEngine {
  static ItemControl q1 = ItemControl([]);

  @override
  loop(int time) {
    if (itemsList.length == yAxisLength * xAxisLength * 0.05) {
      q1.removeAt(random.nextInt(q1.itemsIndex.length));
    }
    q1.join(
        createItem(
//            color: Colors.red ,
            position: Point<int>(random.nextInt(xAxisLength),random.nextInt(yAxisLength)),
            pixelMatrix: [[0,0]]
        )
    );
    q1.moveDown(1);
  }

  @override
  setting() {
    width = 100 ;
    circleTimer = 1 ;
    backgroundColor = Colors.black;
  }

  @override
  setup() {
    
  }

  @override
  onTap() {
//    q1.clear();
  }
  @override
  onHorizontalDragUpdate(DragUpdateDetails details) {
    q1.moveToPoint(Point<int>(details.localPosition.dx.toInt(),details.localPosition.dy.toInt()));
  }
  @override
  onVerticalDragUpdate(DragUpdateDetails details) {
    q1.moveToPoint(Point<int>(details.localPosition.dx.toInt(),details.localPosition.dy.toInt()));

  }
}
