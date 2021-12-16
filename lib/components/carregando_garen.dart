import 'dart:ui';
import 'package:flare_flutter/flare_actor.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class CarregandoScreen extends StatelessWidget {
  final Color color;
  final double opacity;

  const CarregandoScreen({Key key, this.color, this.opacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 1.03,
      child: Stack(
        children: <Widget>[
          new Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 81,
                      height: size.height * 0.05,
                      child: new FlareActor("assets/flrs/carregando.flr",
                          animation: "carregando")),
                  SizedBox(height: 10),
                  ScaleAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "Carregando...",
                      "Instalador Garen",
                      "Pode confiar."
                    ],
                    textStyle: GoogleFonts.audiowide(
                        fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  dismissCarregar(BuildContext context) {
    Navigator.of(context).pop();
  }
}
