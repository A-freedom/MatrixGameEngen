
import 'dart:math';

import 'package:engen/main/engenGate.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Snake extends MatrixEngine  {
 // setting
  @override
  Color get backgroundColor =>Colors.grey[900];

  @override
  Duration setTimer() => Duration(milliseconds: 100);

  @override
  int setXAxisCount() => 100 ;

  Snake(){
    MatrixEngine.items.add(Items(color: Colors.white,pixelsCoordinates: [Point(10, 15)] ));
  }
  var x = 0 ;
  @override
  void logic() {
    if(x>=yAxisCount) x = 0 ;
    MatrixEngine.items[0].pixelsCoordinates = [Point(3, x++)] ;
  }
  @override
  Widget pixel({Key k, Color color}) {
    return Container(
      color: color,
      key: k,
      child: SizedBox(
        height: pixelSize.height,
        width: pixelSize.width,
      ),
    );
  }
}
