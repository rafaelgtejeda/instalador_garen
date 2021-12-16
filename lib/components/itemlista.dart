import 'package:flutter/material.dart';
import 'package:garen/pages/editarInstalacao.dart';

class ItemLista extends StatefulWidget {
  final codigo;
  final String data;
  final String nomeUsuario;
  final Color cor;
  final String telefone;
  final String hora;
  final bool aprovado;

  final Function onPressDetalhes;

  const ItemLista(
      {Key key,
      @required this.codigo,
      @required this.nomeUsuario,
      @required this.data,
      @required this.telefone,
      @required this.cor,
      @required this.onPressDetalhes,
      @required this.hora,
      @required this.aprovado})
      : super(key: key);

  @override
  _ItemListaState createState() => _ItemListaState();
}

class _ItemListaState extends State<ItemLista> {
  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.cor,
          border: Border.all(color: widget.cor /*Color(0xff9e0301)*/, width: 3),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              spreadRadius: 2,
              blurRadius: 10,

              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        height: 82.1314289,
        width: tamanho.width * 0.9,
        child: Column(
          children: [
            Container(
              width: tamanho.width,
              height: 23,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: widget.cor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.5),
                  topRight: Radius.circular(16.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.data,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: tamanho.width,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white, //Color(0xff9e0301),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.nomeUsuario)),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(widget.telefone))
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(widget.hora),
                        Padding(
                          padding: EdgeInsets.only(),
                          child: GestureDetector(
                            onTap: widget.onPressDetalhes,
                            child: Container(
                              width: tamanho.width * 0.09,
                              height: tamanho.height * 0.04,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(60),
                                    topRight: Radius.circular(60)),
                              ),
                              child: GestureDetector(
                                onTap: () => {_sucessoAlerta(context)},
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sucessoAlerta(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                EditarInstalacao(codigo: this.widget.codigo, editar: true)));
  }
}
