
import 'dart:math';

import 'package:engen/main/engenGate.dart';
import 'package:flutter/material.dart';

class Snake extends MatrixEngine  {
 // setting
  @override
  Color get backgroundColor =>Colors.grey[900];

  @override
  Duration setTimer() => Duration(seconds: 1);

  @override
  int setXAxisCount() => 20 ;

  Snake(){
    items.add(Items(color: Colors.white,pixelsCoordinates: [Point(10, 15)] ));
  }
  @override
  void logic() {
    timer = Duration(seconds: 1) ;
    items[0].pixelsCoordinates = [Point(0, 5)] ;
  }
}
