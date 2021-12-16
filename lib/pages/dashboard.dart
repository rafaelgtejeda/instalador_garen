import 'package:flutter/material.dart';
import 'package:garen/pages/catalogo.dart';
import 'package:garen/pages/distribuidor.dart';
import 'package:garen/pages/ferramentas.dart';
import 'package:garen/pages/perfil.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/utils/request.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/pages/home.dart';

class DashboardPage extends StatefulWidget {

  final String idInstalador;
  final int index;

  DashboardPage({Key key, this.index, this.idInstalador}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  LocalizacaoServico _locate = new LocalizacaoServico();
  RequestUtil _requestUtil = new RequestUtil();
  int indexP = 0;

  @override
  void initState() {
    setState(() {
      _locate.iniciaLocalizacao(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String codigo = widget.idInstalador;
    if (widget.idInstalador != null) {
      _requestUtil.saveIdInstaladorShared(
          codigoInstalador: widget.idInstalador);
    }

    final List<Widget> _telas = [
      HomePage(codigo),
      CatalogoPage(codigo),
      DistribuidorPage(codigo),
      FerramentasPage(codigo),
      PerfilPage(codigo),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: LocalizacaoWidget(
        child: StreamBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            backgroundColor: HexColor("004370"),
            appBar: AppBar(
                backgroundColor: HexColor("004370"),
                title: Image.asset(
                  "assets/images/logo-branco.png",
                  fit: BoxFit.cover,
                  width: 100,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false),
                
            body: _telas[widget.index == null ? indexP : widget.index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: indexP,
              backgroundColor: HexColor("012d52"),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: '${_locate.locale['TABS']['home']}',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.assignment,
                    ),
                    label: '${_locate.locale['TABS']['catalog']}'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                    ),
                    label: '${_locate.locale['TABS']['distributor']}'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.build,
                    ),
                    label: '${_locate.locale['TABS']['tools']}'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: '${_locate.locale['TABS']['my_profile']}'),
              ],
              onTap: (index) {
                setState(() {
                  _locate.iniciaLocalizacao(context);
                  indexP = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
