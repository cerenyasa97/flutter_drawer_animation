import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Widget menuButton = Builder(
      builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            CustomDrawer.of(context).toggle();
          }),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomDrawer(child: Homepage(iconButton: menuButton)),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final Widget child;

  CustomDrawer({Key key, this.child}) : super(key: key);

  static _CustomDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomDrawerState>();

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const double _maxWidth = 225;
  static const double dragLeftStartVal = _maxWidth - 20;
  static bool shouldDrag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void close() => _controller.reverse();

  void open() => _controller.forward();

  void toggle() => _controller.isCompleted ? close() : open();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation:
              CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                    center: Alignment(0.0, 0.0),
                    radius: 0.8,
                    colors: [const Color(0xffebcc49), const Color(0xffffc107)],
                    stops: [0.0, 1.0],
                  )),
                ),
                Positioned(
                  top: 60,
                  right: 30,
                  left: 20,
                  child: Row(
                    children: [
                      Flexible(child: IconButton(icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ), onPressed: () => close()), flex: 2,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Jonh Doe",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            "+90 542 546 78 21",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          )
                        ],
                      ), flex:10),
                      Flexible(
                        child: Align(
                          child: Icon(
                            Icons.android,
                            size: 60,
                            color: Colors.white70,
                          ),
                          alignment: Alignment.centerRight,
                        ), flex: 4,)
                    ],
                  ),
                ),
                Positioned(
                  child: CustomDrawerMenu(),
                  top: 220,
                  left: 20,
                ),
                Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..translate(_maxWidth * _controller.value)
                    ..scale(1 - (_controller.value * 0.3)),
                  child: widget.child,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDraggingFromRight = !_controller.isDismissed &&
        details.globalPosition.dx > dragLeftStartVal;
    shouldDrag = isDraggingFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (shouldDrag) {
      double delta = details.primaryDelta / _maxWidth;
      _controller.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlagVelocity = 365;
    double dragVelocity = details.velocity.pixelsPerSecond.dx.abs();
    if (dragVelocity >= _kMinFlagVelocity && shouldDrag) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      _controller.fling(velocity: visualVelocity);
    } else {
      if (_controller.value < 0.5) close();
    }
  }
}

class CustomDrawerMenu extends StatelessWidget {
  const CustomDrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getMenuItem("profile.png", "Profile"),
          _getMenuItem("payment.png", "Payment"),
          _getMenuItem("trips.png", "My Trips"),
          _getMenuItem("emergency.png", "Emergency\nContact", height: 75),
          _getMenuItem(
            "help.png",
            "Help &\nSupport",
          )
        ],
      ),
    );
  }

  _getMenuItem(String image, String title, {double height}) {
    return GestureDetector(
      child: Container(
        height: height ?? 55,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(37.0),
          border: Border.all(width: 2.0, color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "images/" + image,
              width: 32,
            ),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  final Widget iconButton;

  const Homepage({Key key, this.iconButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Row(
          children: [iconButton, Text("Homepage")],
        ),
      ),
      body: Center(
        child: Text("HomePage"),
      ),
    );
  }
}
