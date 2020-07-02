import 'dart:math';
import 'dart:ui';

import 'package:engen/main/engineGate.dart';
import 'package:flutter/cupertino.dart';

bool isNotNull(val) => (val != null) ? true : false;

/*the Item class it use to save & manage the items properties */
class Item {
  Color color;
  bool active;
  List<Point<int>> pixelsCoordinates;
  Point<int> itemPosition;

  Item({this.color, this.pixelsCoordinates, this.active, this.itemPosition});
}

class ItemControl {
  List<UniqueKey> itemsIndex;

  ItemControl(this.itemsIndex);

  void insertItem(UniqueKey key) {
    itemsIndex.add(key);
  }

  void join(ItemControl control) {
    itemsIndex += control.itemsIndex;
  }

  void loopInPoints(Point p(Point p)) {
    itemsIndex.forEach((key) {
      for (var i = 0;
          i < MatrixEngine.items[key].pixelsCoordinates.length;
          i++) {
        MatrixEngine.items[key].pixelsCoordinates[i] =
            p(MatrixEngine.items[key].pixelsCoordinates[i]);
      }
    });
  }

  void loopInItems(void i(Item item)) {
    itemsIndex.forEach((index) {
      i(MatrixEngine.items[index]);
    });
  }

  void moveUp(int p) {
    loopInItems((item) {
      item.itemPosition =
          Point<int>(item.itemPosition.x, item.itemPosition.y - p);
    });
  }

  void moveDown(int p) {
    loopInItems((item) {
      item.itemPosition =
          Point<int>(item.itemPosition.x, item.itemPosition.y + p);
    });
  }

  void moveLeft(int p) {
    loopInItems((item) {
      item.itemPosition =
          Point<int>(item.itemPosition.x - p, item.itemPosition.y);
    });
  }

  void moveRight(int p) {
    loopInItems((item) {
      item.itemPosition =
          Point<int>(item.itemPosition.x + p, item.itemPosition.y);
    });
  }

  void moveToPoint(Point point) {
    itemsIndex.forEach((index) {
      MatrixEngine.items[index].itemPosition = Point<int>(point.x, point.y);
    });
  }

  void rotation() {
    final r = [
      [3, -2],
      [1, 2]
    ];
    loopInPoints((p) => Point<int>(
        (r[0][0] * p.x) + (r[0][1] * p.y), (r[1][0] * p.x) + (r[1][1] * p.y)));
//      loopInPoints((p) => Point<int>(p.x+1,p.y+1));
  }

  void clear() {
    itemsIndex.forEach((index) {
      MatrixEngine.items.remove(index);
    });
    itemsIndex.clear() ;
  }


  ItemControl operator + (ItemControl other) {
    itemsIndex.addAll(other.itemsIndex) ;
    return new ItemControl(itemsIndex);
  }

  Item removeAt(int index) => MatrixEngine.items.remove(itemsIndex.removeAt(index)) ;
}

mixin MyMath {
  /*$q1 should be less than $q2*/
  bool isBetween(angle, q1, q2) => (angle < q2 && angle > q1) ? true : false;
}
