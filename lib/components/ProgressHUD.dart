import 'package:flutter/material.dart';
import 'package:garen/components/carregando_garen.dart';
import 'dart:ui';

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.blue,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();

    widgetList.add(child);

    if (inAsyncCall) {
      final modal = new CarregandoScreen(color: color, opacity: opacity);

      widgetList.add(modal);
    }

    return Stack(
      children: widgetList,
    );
  }
}
