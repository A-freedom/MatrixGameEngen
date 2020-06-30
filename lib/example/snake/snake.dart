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
  static ItemControl top = ItemControl([]),left = ItemControl([]),down = ItemControl([]),right = ItemControl([]);

  @override
  loop() {
    top.join(createItem(
        pixelMatrix: [[0, 0]],
        position: Point<int>(random.nextInt(xAxisLength), random.nextInt(yAxisLength))));
    left.join(createItem(
        pixelMatrix: [[0, 0]],
        position: Point<int>(random.nextInt(xAxisLength), random.nextInt(yAxisLength))));
    down.join(createItem(
            pixelMatrix: [[0, 0]],
            position: Point<int>(random.nextInt(xAxisLength), random.nextInt(yAxisLength))));
    right.join(createItem(
            pixelMatrix: [[0, 0]],
            position: Point<int>(random.nextInt(xAxisLength), random.nextInt(yAxisLength))));

    if (top.itemsIndex.length > yAxisLength * xAxisLength~/25) {
      top.removeAt( random.nextInt(top.itemsIndex.length) );
    }
    if (left.itemsIndex.length > yAxisLength * xAxisLength~/25) {
      left.removeAt( random.nextInt(left.itemsIndex.length) );
    }
    if (down.itemsIndex.length > yAxisLength * xAxisLength~/25) {
      down.removeAt( random.nextInt(down.itemsIndex.length) );
    }
    if (right.itemsIndex.length > yAxisLength * xAxisLength~/25) {
      right.removeAt( random.nextInt(right.itemsIndex.length) );
    }
    top.moveDown(1);
    left.moveRight(1);
//    down.moveUp(1);
//    right.moveLeft(1);
  }

  @override
  setting() {
    width = 14;
    backgroundColor = Colors.black;
    circleTimer = 2000;
    pixel = ({Color color}) {
      return Container(
        padding: EdgeInsets.all(1),
        child: Container(
          child: SizedBox(
            width: pixelSize.width - 2,
            height: pixelSize.height - 2,
            child: Center(
              child: Text(random.nextInt(2).toString(),style: TextStyle(color: color,fontSize: pixelSize.height-1),),
            ),
          ),
        ),
      );
    };
  }

  @override
  setup() {}
  @override
  onTap() {
    top.clear();
    left.clear();
    right.clear();
    down.clear();
  }


}
