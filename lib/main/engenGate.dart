import 'dart:async';
import 'dart:math';

import 'package:engen/main/etc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
abstract class MatrixEngine extends StatefulWidget {
  /*set the default values of the timer and the xAxisCount
  * and make sure that no one of them is (NULL) */

  /*---------------------SETTER---------------------*/


  MatrixEngine() {
    timer = setTimer();
    xAxisCount = setXAxisCount();
    assert(isNotNull(xAxisCount));
    assert(isNotNull(timer));
  }
  /*---------------------OVERRIDE ASSERT---------------------*/

  Duration setTimer();

  int setXAxisCount();

  logic();


  /*---------------------DEFINE GLOBAL VARIABLES---------------------*/

  /*this just a instance of random object I but it her just because I thought it
  * will get used of mange times in any future functions of user usage*/
  Random random = new Random();

  /* set a background color */
  Color backgroundColor;

  /* it is the size of the Widget builder*/
  Size boxSize;

  /* it is the size of one pixel */
  Size pixelSize;

  /* it is the size of touch area */
  Size gestureSize;

  /*the amount of pixel in x axis and y axis
  * the $xAxisCount got a default value of
  * but still it most likely that the user will set this value
  * the 10 value here for just avoid
  * (CALL ON NULL ERROR) if the user forget to set a value
  * and the $yAxisCount it get set by the screen height */
  int xAxisCount = 10, yAxisCount;

  /* this is the array of (x,y) matrix
  *  it is work by first set each pixel globalKey the after all widget tree get
  * rendered it will run the get $getPositions(GlobalKey k) function  then set
  * the value in its place in the $_offsetList 2D matrix*/
  List<List<Key>> _keysList = new List();
  List<List<Offset>> _offsetList = new List();

  /*this is the main loop it will call the 'periodic' Depending on the timer
  * the periodic will fire the $logic() function then rebuild the $Viewer Widget  */
  Timer loop;
  Duration timer;

  /*this is the list of item that will build on  the screen in each frame
  * the $Items class could content a list of points and its color that will render
  * on the screen and could content list of $Items that should in theory help to
  * render complex object on the screen than control them*/
  List<Items> items = new List();

  /*this function should return a list of widget contend in container each one of
  * them is a Positioned widget  each Positioned widget it is a pixel on the screen
  * that represent on point with its color that came from the $items list*/

  /*---------------------THIS CLASS FUNCTIONS---------------------*/

  Widget get timesView {
    // this just in case to avoid (WIDGET SHOULDN'T BE NULL ERROR)
    if (_offsetList.isEmpty) return Container();
    // create a interim list to content all Positioned widget
    List<Widget> pList = new List();
    /*looping through all items point and cast each point to a $Pixel widget with
     its color then  add it interim list $(pList) */
    items.forEach((item) {
      item.pixelsCoordinates.forEach((coordinate) {
        final offset = _offsetList[coordinate.x][coordinate.y];
        pList.add(Positioned(
          left: offset.dx,
          top: offset.dy,
          child: pixel(color: item.color),
        ));
      });
    });
    // put the list of positioned widget in container then return it
    return Container(
      child: Stack(
        children: pList,
      ),
    );
  }

  // ignore: missing_return
  Offset getPositions(GlobalKey k) {
    final RenderBox renderBoxRed = k.currentContext.findRenderObject();
    return renderBoxRed.localToGlobal(Offset.zero);
  }

  Widget backgroundNet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List(xAxisCount).map((e) {
        _keysList.add(new List());
        return Column(
          children: List(yAxisCount).map((e) {
            final k = new GlobalKey();
            final w = pixel(k: k);
            _keysList.last.add(k);
            return w;
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget pixel({Key k, Color color}) => Container(
        key: k,
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: (isNotNull(color)) ? color : Colors.blue,
            child: SizedBox(
              width: pixelSize.width - 4,
              height: pixelSize.height - 4,
            ),
          ),
        ),
      );

  @override
  _MatrixEngineState createState() => _MatrixEngineState();
}

class _MatrixEngineState extends State<MatrixEngine> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _assembly();
      _refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      widget.backgroundColor ??= Colors.grey;
      /* by default it is grey */
      widget.boxSize ??= constraints.biggest;
      /* by default owner widget */
      widget.gestureSize ??= widget.boxSize;
      /* it is the size of the touch listener by default owner widget */
      widget.pixelSize ??= Size((widget.boxSize.width / widget.xAxisCount),
          (widget.boxSize.width / widget.xAxisCount));
      /* it is automatic set dependent to the boxSize and the xAxisCount  */
      widget.yAxisCount ??=
          (widget.boxSize.height ~/ widget.pixelSize.width).toInt();
      /* by default it get by divided the widget height into the one pixel size  */

      return Container(
        color: widget.backgroundColor,
        child: Stack(
          children: <Widget>[widget.backgroundNet(), widget.timesView],
        ),
      );
    });
  }

  _refresh() async {
    void run() {
      widget.loop?.cancel();
      widget.loop = Timer.periodic(widget.timer, (timer) {
        // TODO makes this rebuilt just the viewer widget no the engine widget
        setState(() {
          widget.logic();
          run();
        });
      });
    }

    run();
  }

  _assembly() {
    widget._keysList.forEach((x) {
      widget._offsetList.add(new List());
      x.forEach((k) {
        widget._offsetList.last.add(widget.getPositions(k));
      });
    });
  }
}

class Items {
  Color color;
  bool active;
  List<Point> pixelsCoordinates;

  Items({this.color, this.pixelsCoordinates, this.active});
}
