import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:hexcolor/hexcolor.dart';

class AppBarComponent extends StatefulWidget {
  final String backgroundColor;
  final Function onpressed;
  final centerTitle;
  final bool visivel;

  AppBarComponent(
      {this.onpressed,
      @required this.visivel,
      @required this.backgroundColor,
      @required this.centerTitle});

  @override
  _AppBarComponentState createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  LocalizacaoServico _locate = new LocalizacaoServico();

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AppBar(
          backgroundColor: HexColor(widget.backgroundColor),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Image.asset(
            "assets/images/logo-branco.png",
            fit: BoxFit.cover,
            width: 100,
          ),
          centerTitle: widget.centerTitle,
          actions: <Widget>[
            Visibility(
              visible: widget.visivel,
              child: FlatButton(
                textColor: Colors.white,
                onPressed: widget.onpressed,
                child: Row(
                  children: [
                    Text("${_locate.locale['AUTOMAT']['clear']}"),
                  ],
                ),
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.005),
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                        Color(0xff8b1924),
                        Color(0xff4d1627),
                        Color(0xff00141c),
                        Color(0xff4d1627),
                        Color(0xff8b1924),
                      ]
                    )
                ),
                height: 4),
          ),
        );
      }),
    );
  }
}
