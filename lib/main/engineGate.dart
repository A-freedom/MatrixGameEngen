/*
d8888b. db       .d8b.   .o88b. db   dD   db      d888888b db    db d88888b .d8888.   .88b  d88.  .d8b.  d888888b d888888b d88888b d8888b.
88  `8D 88      d8' `8b d8P  Y8 88 ,8P'   88        `88'   88    88 88'     88'  YP   88'YbdP`88 d8' `8b `~~88~~' `~~88~~' 88'     88  `8D
88oooY' 88      88ooo88 8P      88,8P     88         88    Y8    8P 88ooooo `8bo.     88  88  88 88ooo88    88       88    88ooooo 88oobY'
88~~~b. 88      88~~~88 8b      88`8b     88         88    `8b  d8' 88~~~~~   `Y8b.   88  88  88 88~~~88    88       88    88~~~~~ 88`8b
88   8D 88booo. 88   88 Y8b  d8 88 `88.   88booo.   .88.    `8bd8'  88.     db   8D   88  88  88 88   88    88       88    88.     88 `88.
Y8888P' Y88888P YP   YP  `Y88P' YP   YD   Y88888P Y888888P    YP    Y88888P `8888Y'   YP  YP  YP YP   YP    YP       YP    Y88888P 88   YD*/

import 'dart:async';
import 'dart:math';

import 'package:engen/main/etc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
abstract class MatrixEngine extends StatefulWidget {
  MatrixEngine() {
    setting();
  }

  void Function() rebuild;

/*++++++++++++++++setter++++++++++++++++*/

  set circleTimer(int fps) {
    _timer = Duration(milliseconds: fps);
    if (isNotNull(_startNewPeriodic)) {
      _startNewPeriodic();
    }
//    if(isNotNull(rebuild)){
//      rebuild();
//    }
  }

  set width(int width) {
    _xAxisLength = width;
    if (isNotNull(rebuild)) rebuild();
  }

  set interactWithTheEdges(String react) => _interactWithTheEdges = react;

  set gestureSize(Size size) {
    _gestureSize = size;
    if (isNotNull(rebuild)) rebuild();
  }

  set pixel(Function pi) {
    _pixel = pi;
  }

  set itemsList(Map list) {
    items = list;
  }

  set setBackgroundColor(Color color) {
    backgroundColor = color;
//    rebuild() ;
  }

/*++++++++++++++++getter++++++++++++++++*/

/*this just a instance of R&om class I put it here just because I thought it
  * it will get used so many times in any future functions of user usage
  *
  * NOTE: I disable this variable until I will need it*/

  Random random = new Random();

  Color backgroundColor;

  Offset get enginePosition => engineOffset;

  Size get boxSize => _boxSize;

  Size get pixelSize => _pixelSize;

  Size get gestureSize => _gestureSize;

  int get xAxisLength => _xAxisLength;

  int get yAxisLength => _yAxisLength;

  Timer get loopControl => _loopControl;

  Map get itemsList => items;

  Function _pixel = ({Color color}) {
    return Container(
      padding: EdgeInsets.all(1),
      child: Container(
        color: (isNotNull(color)) ? color : Colors.grey[700],
        child: SizedBox(
          width: _pixelSize.width - 2,
          height: _pixelSize.height - 2,
        ),
      ),
    );
  };

/*++++++++++++++++OVERRIDE ASSERT++++++++++++++++*/

  loop(int time);

  setup();

  setting();

/*???????????????? TOUCH CONTROL ????????????????*/

  onTap() {}

  onTapCancel() {}

  onTapUp(TapUpDetails details) {}

  onTapDown(TapDownDetails details) {}

  onLongPress() {}

  onLongPressEnd(LongPressEndDetails details) {}

  onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {}

  onLongPressUp() {}

  ongPressStart(LongPressStartDetails details) {}

  onLongPressStart(LongPressStartDetails details) {}

  onSwapUp(DragEndDetails details) {}

  onSwapDown(DragEndDetails details) {}

  onSwapLeft(DragEndDetails details) {}

  onSwapRight(DragEndDetails details) {}

  onVerticalDragUpdate(DragUpdateDetails details) {}

  onHorizontalDragUpdate(DragUpdateDetails details) {}

/*++++++++++++++++Public allowed+++++++++++++++*/

  static String _interactWithTheEdges = 'invert';

  static Offset engineOffset;

/* it is the size of the Widget builder*/
  static Size _boxSize;

/* it is the size of one pixel */
  static Size _pixelSize;

/* it is the size of touch area */
  Size _gestureSize;

/*the amount of pixel in x axis & y axis
  * the $xAxisCount got a default value is 10
  * but still it most likely that the user will set this value
  * the 10 value here for just avoid
  * (CALL ON NULL ERROR) if the user forget to set a value
  * & the $yAxisCount it get set by the screen height */
  static int _xAxisLength = 10, _yAxisLength;

/* this is the array of (x,y) matrix
  *  it is work by first set each pixel globalKey the after all widget tree get
  * rendered it will run the get $getPositions(GlobalKey k) function  then set
  * the value in its place in the $_offsetList 2D matrix
  * NOTE: the $_keysList is set to static & the $_keyList is moved to $ItemsDisplay class*/
//  static List<List<Key>> _keysList = new List();

/*this is the main loop it will call the 'periodic' Depending on the timer
  * the periodic will fire the $logic() function then rebuild the $Viewer Widget
  *
  * NOTE: these tow variable are set to static because I needed to control
  * them from $ItemsDisplay class */

  static Timer _loopControl;
  static Duration _timer;

/*this is the list of item that will build on  the screen in each frame
  * the $Items class could content a list of points & its color that will render
  * on the screen & could content list of $Items that should in theory help to
  * render complex object on the screen than control them*/
  static Map<UniqueKey, Item> items = new Map<UniqueKey, Item>();

/*++++++++++++++++THIS CLASS FUNCTIONS++++++++++++++++*/

  ItemControl createItem(
      {List<List<int>> pixelMatrix, Color color, Point<int> position}) {
    final coordinates = pixelMatrix.map((e) => Point<int>(e[0], e[1])).toList();
    color = (isNotNull(color))
        ? color
        : Color.fromRGBO(random.nextInt(244), random.nextInt(244),
            random.nextInt(244), random.nextInt(244).toDouble());
    final key = new UniqueKey();
    items[key] = (Item(
        pixelsCoordinates: (coordinates),
        itemPosition: position,
        color: color));
    return ItemControl([key]);
  }

/*this function is get set from low level class . it use to set new timer &
  * fire setState from the class $ItemsViewer .
  *
  * NOTE : the itemsViewer for now is function in the future it will get refactor
  *        to StatefulWidget class
  *
  * NOTE: $itemsViewer is get replace with the $ItemDisplay class &
  * the function get set to static*/
  static Function _startNewPeriodic;

/* create the main Widget by Override the createState() */
  @override
  _MatrixEngineState createState() => _MatrixEngineState();
}

class _MatrixEngineState extends State<MatrixEngine> with MyMath {
/*++++++++++++++++OVERRIDE EXTENDS FUNCTIONS++++++++++++++++*/
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.setup();
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (MatrixEngine._startNewPeriodic != null) {
      widget.setup();
    }
//TODO remove this when you be out of developing time
    super.setState(fn);
  }

/*override the build function to  build my engine widget*/
  @override
  Widget build(BuildContext context) {
    widget.rebuild = () => setState(() {});

    assert(isNotNull(MatrixEngine._xAxisLength));
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTapDown,
      onTapUp: (d) => widget.onTapUp,
      onTapCancel: () => widget.onTapCancel,
      onLongPress: widget.onLongPress,
      onLongPressStart: widget.onLongPressStart,
      onLongPressEnd: widget.onLongPressEnd,
      onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
      onLongPressUp: widget.onLongPressUp,
      onVerticalDragUpdate: widget.onVerticalDragUpdate,
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      onHorizontalDragEnd: (DragEndDetails details) {
        final direction =
            details.velocity.pixelsPerSecond.direction * (180 / pi);
        final angle = (direction < 0) ? direction + 360 : direction;
        if (isBetween(angle, 0, 45) || isBetween(angle, 315, 359)) {
          widget.onSwapRight(details);
        } else if (isBetween(angle, 135, 225)) {
          widget.onSwapLeft(details);
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        final direction =
            details.velocity.pixelsPerSecond.direction * (180 / pi);
        final angle = (direction < 0) ? direction + 360 : direction;
        if (isBetween(angle, 255, 359)) {
          widget.onSwapUp(details);
        } else if (isBetween(angle, 45, 135) || isBetween(angle, 315, 359)) {
          widget.onSwapDown(details);
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        MatrixEngine.engineOffset = constraints.biggest.topLeft(Offset.zero);
/* by default it is grey */
        widget.backgroundColor ??= Colors.grey;

/* by default owner widget */
        MatrixEngine._boxSize ??= constraints.biggest;

/* it is the size of the touch listener by default owner widget */
        widget._gestureSize ??= MatrixEngine._boxSize;

/* it is automatic set dependent to the boxSize & the xAxisCount  */
        MatrixEngine._pixelSize ??= Size(
            (MatrixEngine._boxSize.width / MatrixEngine._xAxisLength),
            (MatrixEngine._boxSize.width / MatrixEngine._xAxisLength));

/* by default it get by divided the widget height into the one pixel size  */
        MatrixEngine._yAxisLength ??=
            (MatrixEngine._boxSize.height ~/ MatrixEngine._pixelSize.width)
                .toInt();

        return Container(
          color: widget.backgroundColor,
          child: Stack(
            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: List(MatrixEngine._xAxisLength).map((e) {
//                  return Column(
//                    children: List(MatrixEngine._yAxisLength).map((e) {
//                      final w = widget._pixel();
//                      return w;
//                    }).toList(),
//                  );
//                }).toList(),
//              )
//              ,
              ItemsDisplay(pixel: widget._pixel, loop: widget.loop)
            ],
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class ItemsDisplay extends StatefulWidget {
  Function loop;
  Function pixel;

  ItemsDisplay({this.loop, this.pixel});

  @override
  _ItemsDisplayState createState() => _ItemsDisplayState();
}

class _ItemsDisplayState extends State<ItemsDisplay> {
/*++++++++++++++++DEFINE GLOBAL VALUES++++++++++++++++*/

/*this 2D matrix used to save all pixels positioned
  *
  * NOTE: the value used to be in the main engine class
  * it get moved to here because be in the main class t is no longer required */

/*++++++++++++++++OVERRIDE EXTENDS FUNCTIONS++++++++++++++++*/

/*this override used to fire some functions once this widget get render*/
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      MatrixEngine._startNewPeriodic = _startPeriodic;
      _startPeriodic();
    });
  }

  Point foo(Point p) {
    int x = p.x, y = p.y;

    if (x > MatrixEngine._xAxisLength - 1) {
      x %= MatrixEngine._xAxisLength;
    }
    if (x < 0) {
      x %= MatrixEngine._xAxisLength - 1;
      x += MatrixEngine._xAxisLength - 1;
    }
    if (y > MatrixEngine._yAxisLength - 1) {
      y %= MatrixEngine._yAxisLength;
    }
    if (y < 0) {
      y %= MatrixEngine._yAxisLength - 1;
      y += MatrixEngine._yAxisLength - 1;
    }
    return Point<double>(x.toDouble(), y.toDouble());
  }

  /*this override the build function to build the _Items on the screen  */
  @override
  Widget build(BuildContext context) {
    assert(MatrixEngine._interactWithTheEdges == 'invert' ||
        MatrixEngine._interactWithTheEdges == 'cross' ||
        MatrixEngine._interactWithTheEdges == 'block');

    final list = List<PixelOffset>();
    MatrixEngine.items.values.forEach((item) {
      item.pixelsCoordinates.forEach((p) {
        item.itemPosition = intPoint(foo(item.itemPosition));
        Point point = foo(p + item.itemPosition);
        point *= MatrixEngine._pixelSize.width;
        list.add(PixelOffset(point.x, point.y, item.color));
      });
    });
    return Container(
      child: Stack(
        children: <Widget>[
          CustomPaint(
            painter: PixelsPainter(list),
            size: MatrixEngine._boxSize,
          )
        ],
      ),
    );
  }

  _startPeriodic() async {
    MatrixEngine._loopControl?.cancel();
    MatrixEngine._loopControl = Timer.periodic(MatrixEngine._timer, (t) {
      setState(() {
        widget.loop(t.tick);
      });
    });
  }

  Offset getPositionByPoint(Point<int> coordinatePoint) {
    return Offset(coordinatePoint.x * MatrixEngine._boxSize.width,
        coordinatePoint.y * MatrixEngine._boxSize.height);
  }

  Point<int> intPoint(Point p) => Point<int>(p.x.toInt(), p.y.toInt());
}

class PixelOffset extends Offset {
  final Color color;

  PixelOffset(double dx, double dy, this.color) : super(dx, dy);
}

class PixelsPainter extends CustomPainter {
  final List<PixelOffset> list;

  PixelsPainter(this.list);

  @override
  void paint(Canvas canvas, Size size) {

    var fillBrush = Paint();

    list.forEach((pixelOffset) {
      fillBrush.color = pixelOffset.color;
      canvas.drawRect(
          Rect.fromCircle(radius: MatrixEngine._pixelSize.width/2, center: pixelOffset), fillBrush);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
