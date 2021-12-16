import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:garen/pages/notificacao.dart';
import 'package:garen/provider/banner_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:garen/provider/notificacoes_provider.dart';
import 'package:garen/components/animation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String texto;

  HomePage(this.texto);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notificationManager;
  var total;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                     colors: [
                    Color(0xff8e1729),
                    Color(0xff4d1627),
                    Color(0xff00141c),
                    Color(0xff4d1627),
                    Color(0xff8e1729),
                  ])),
              height: MediaQuery.of(context).size.height * 0.005),

          //Acima do Card
          Padding(
            padding: EdgeInsets.only(top: tamanho.height * 0.004),
            child: Container(
              width: tamanho.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_azul.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Consumer<BannerManager>(builder: (_, bannerManager, __) {
                return FutureBuilder(
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData == null) {
                      return Center(
                        child: Text('Sem informações'),
                      );
                    } else if (snapshot.hasData == false &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CarregandoScreen(
                        color: Colors.blue[900],
                        opacity: 0.5,
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data['data'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 12.0, bottom: 8.0, right: 12.0),
                          child: Material(
                            elevation: 5,
                            child: InkWell(
                              onTap: () async {
                                var url =
                                    snapshot.data['data'][index]['ban_c_link'];

                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: FadeInUp(
                                  index,
                                  Card(
                                      elevation: 5,
                                      child: snapshot.data['data'][index]
                                                  ['ban_c_imagem'] !=
                                              null
                                          ? Image.memory(convertImage64(
                                              snapshot.data['data'][index]
                                                  ['ban_c_imagem']))
                                          : Text('Carregando'))),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  future: bannerManager.bannerService.getBanner(),
                );
              }),
            ),
            // Positioned para a appBar usar comente o tamanho dela.
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      NotificacoesPage(idInstalador: widget.texto ?? "nulo")));
        },
        backgroundColor: Colors.white,
        child: Consumer<NotificacoesManager>(
            builder: (_, notificationManager, __) {
          notificationManager.notificacaoContador(
              idInstalador: widget.texto ?? "nulo",
              onSuccess: (v) async {
                total = v;
              });
          if (total != 0) {
            return Badge(
              padding: EdgeInsets.all(8),
              position: BadgePosition.topEnd(top: -28, end: -17),
              badgeColor: Colors.red,
              badgeContent: Text(
                  total.toString() == 'null' ? '•' : total.toString(),
                  style: TextStyle(color: Colors.white)),
              child: Icon(
                Icons.notifications,
                color: Colors.red,
              ),
            );
          } else {
            return Badge(
                badgeColor: Colors.white,
                elevation: 0.0,
                child: Icon(
                  Icons.notifications,
                  color: Colors.red,
                ));
          }
        }),
      ),
    );
  }

  convertImage64(String img64) {
    var _img64 = base64Decode(img64);
    return _img64;
  }
}
