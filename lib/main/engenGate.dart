import 'dart:async';
import 'dart:math';

import 'package:engen/main/etc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: must_be_immutable
abstract class MatrixEngine extends StatefulWidget {
  /*++++++++++++++++SETTER++++++++++++++++*/

  /*set the default values of the timer & the xAxisCount
  * & make sure that no one of them is (NULL) */

  MatrixEngine() {
    timer = setTimer();
    xAxisCount = setXAxisCount();
    assert(isNotNull(xAxisCount));
    assert(isNotNull(timer));
  }

  /*++++++++++++++++OVERRIDE ASSERT++++++++++++++++*/

  Duration setTimer();

  int setXAxisCount();

  logic();

  /*++++++++++++++++DEFINE GLOBAL VARIABLES++++++++++++++++*/

  /*this just a instance of R&om class I put it here just because I thought it
  * it will get used so many times in any future functions of user usage
  *
  * NOTE: I disable this variable until I will need it*/

//  Random random = new Random();

  /* set a background color */
  Color backgroundColor;

  /* it is the size of the Widget builder*/
  Size boxSize;

  /* it is the size of one pixel */
  Size pixelSize;

  /* it is the size of touch area */
  Size gestureSize;

  /*the amount of pixel in x axis & y axis
  * the $xAxisCount got a default value is 10
  * but still it most likely that the user will set this value
  * the 10 value here for just avoid
  * (CALL ON NULL ERROR) if the user forget to set a value
  * & the $yAxisCount it get set by the screen height */
  int xAxisCount = 10, yAxisCount;

  /* this is the array of (x,y) matrix
  *  it is work by first set each pixel globalKey the after all widget tree get
  * rendered it will run the get $getPositions(GlobalKey k) function  then set
  * the value in its place in the $_offsetList 2D matrix
  * NOTE: the $_keysList is set to static & the $_keyList is moved to $ItemsDisplay class*/
  static List<List<Key>> _keysList = new List();


  /*this is the main loop it will call the 'periodic' Depending on the timer
  * the periodic will fire the $logic() function then rebuild the $Viewer Widget
  *
  * NOTE: these tow variable are set to static because I needed to control
  * them from $ItemsDisplay class */
  static Timer loop;
  static Duration timer;

  /*this is the list of item that will build on  the screen in each frame
  * the $Items class could content a list of points & its color that will render
  * on the screen & could content list of $Items that should in theory help to
  * render complex object on the screen than control them*/
  static List<Items> items = new List();

  /*++++++++++++++++THIS CLASS FUNCTIONS++++++++++++++++*/

  /*this function is get set from low level class . it use to set new timer &
  * fire setState from the class $ItemsViewer .
  *
  * NOTE : the itemsViewer for now is function in the future it will get refactor
  *        to StatefulWidget class
  *
  * NOTE: $itemsViewer is get replace with the $ItemDisplay class &
  * the function get set to static*/
  static Function(Duration timer) setNewPeriodic;

  /*this function return a Row content a Columns .
  * row children length = xAxis
  * column children length = yAxis*/
  Widget backgroundNet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List(xAxisCount).map((e) {
        _keysList.add(new List());
        return Column(
          children: List(yAxisCount).map((e) {
            // set the pixel widget get in the global _keysList matrix
            final k = new GlobalKey();
            final w = pixel(k: k);
            _keysList.last.add(k);
            return w;
          }).toList(),
        );
      }).toList(),
    );
  }

  /*this function return on single pixel with its color it is able to customise
  * by override it in the user class */
  Widget pixel({Key k, Color color}) =>
      Container(
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

  /* create the main Widget by Override the createState() */
  @override
  _MatrixEngineState createState() => _MatrixEngineState();
}

class _MatrixEngineState extends State<MatrixEngine> {
  /*++++++++++++++++OVERRIDE EXTENDS FUNCTIONS++++++++++++++++*/

  /*override the build function to  build my engine widget*/
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
      /* it is automatic set dependent to the boxSize & the xAxisCount  */
      widget.yAxisCount ??=
          (widget.boxSize.height ~/ widget.pixelSize.width).toInt();
      /* by default it get by divided the widget height into the one pixel size  */

      return Container(
        color: widget.backgroundColor,
        child: Stack(
          children: <Widget>[
            widget.backgroundNet(),
            ItemsDisplay(pixel: widget.pixel, logic: widget.logic,)
          ],
        ),
      );
    });
  }

}
/*the Items class it use to save & manage the items properties */
class Items {
  Color color;
  bool active;
  List<Point> pixelsCoordinates;

  Items({this.color, this.pixelsCoordinates, this.active});
}

// ignore: must_be_immutable
class ItemsDisplay extends StatefulWidget {
  Function logic;
  Function pixel;

  ItemsDisplay({this.logic, this.pixel});

  @override
  _ItemsDisplayState createState() => _ItemsDisplayState();
}

class _ItemsDisplayState extends State<ItemsDisplay> {
  /*++++++++++++++++DEFINE GLOBAL VALUES++++++++++++++++*/

  /*this 2D matrix used to save all pixels positioned
  *
  * NOTE: the value used to be in the main engine class
  * it get moved to here because be in the main class t is no longer required */
  List<List<Offset>> _offsetList = new List();


  /*++++++++++++++++OVERRIDE EXTENDS FUNCTIONS++++++++++++++++*/

  /*this override used to fire some functions once this widget get render*/
  @override
  void initState() {
    /*TODO: make sure that is function fired once this
       widget get rendered and just for one time not ever time this widget
       get rebuild*/
    MatrixEngine.setNewPeriodic = _startPeriodic;
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _assembly();
      _startPeriodic(MatrixEngine.timer);
    });
  }
  /*this override the build function to build the Items on the screen  */
  @override
  Widget build(BuildContext context) {
    // this just in case to avoid (WIDGET SHOULDN'T BE NULL ERROR)
    if (_offsetList.isEmpty) return Container();
    // create a interim list to content all Positioned widget
    List<Widget> pList = new List();
    /*looping through all items point & cast each point to a $Pixel widget with
     its color then  add it interim list $(pList) */
    MatrixEngine.items.forEach((item) {
      item.pixelsCoordinates.forEach((coordinate) {
        final offset = _offsetList[coordinate.x][coordinate.y];
        pList.add(Positioned(
          left: offset.dx,
          top: offset.dy,
          child: widget.pixel(color: item.color),
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

  _startPeriodic(Duration timer) async {
    MatrixEngine.timer = timer;
    MatrixEngine.loop?.cancel();
    MatrixEngine.loop = Timer.periodic(timer, (t) {
      setState(() {
        widget.logic();
      });
    });
  }

  _assembly() {
    MatrixEngine._keysList.forEach((x) {
      _offsetList.add(new List());
      x.forEach((k) {
        _offsetList.last.add(getPositions(k));
      });
    });
  }

  /*this function is to get the offset of widget by it own unique KEY*/
  Offset getPositions(GlobalKey k) {
    final RenderBox renderBoxRed = k.currentContext.findRenderObject();
    return renderBoxRed.localToGlobal(Offset.zero);
  }

}
