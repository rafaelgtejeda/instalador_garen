import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardInputComponente extends StatefulWidget {
  const CardInputComponente({
    this.titulo,
    this.subtitulo,
    this.validator,
    @required this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.prefixTexto,
    this.onchanged,
    this.dica,
  });

  final String titulo;
  final String subtitulo;
  final Function(String) onchanged;
  final Function(String) validator;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String prefixTexto;
  final String dica;

  @override
  _CardInputComponenteState createState() => _CardInputComponenteState();
}

class _CardInputComponenteState extends State<CardInputComponente> {
  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: tamanho.height * 0.02),
      child: Container(
        width: tamanho.width * 0.875,
        height: 119,
        decoration: BoxDecoration(
          color: Color(0xfffe0000),
          border: Border.all(color: Color(0xff9e0301), width: 3),
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,

              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 0),
              child: Text(
                widget.titulo,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 10),
              child: Text(
                widget.dica,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10 * MediaQuery.of(context).textScaleFactor),
              ),
            ),
            TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              autofocus: false,
              textAlign: TextAlign.center,
              inputFormatters: widget.inputFormatters,
              onSaved: (val) => setState(() => widget.controller.text = val),
              onChanged: widget.onchanged,
              validator: widget.validator,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17 * MediaQuery.of(context).textScaleFactor,
                  fontWeight: FontWeight.w900),
              decoration: InputDecoration(
                prefix:
                    Text(widget.prefixTexto != null ? widget.prefixTexto : ''),
                prefixStyle: TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () {
                    widget.controller.text = '';
                  },
                  color: Colors.red[100],
                  icon: Icon(widget.controller.text != null ||
                          widget.controller.text != ''
                      ? Icons.delete
                      : Icons.delete_outline),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: widget.dica,
                hintStyle: TextStyle(
                    fontSize: 11 * MediaQuery.of(context).textScaleFactor,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w900),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(9.5),
                      bottomLeft: Radius.circular(9.5),
                      topLeft: Radius.circular(0)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(9.5),
                      bottomLeft: Radius.circular(9.5),
                      topLeft: Radius.circular(0)),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
