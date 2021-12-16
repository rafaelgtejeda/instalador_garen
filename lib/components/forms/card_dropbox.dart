import 'package:flutter/material.dart';

class CardDropboxComponente extends StatefulWidget {
  final String titulo;
  final String hintTexto;
  final String dropdownValue;
  final Function(String) onchanged;
  final List<String> items;
  final double height;

  CardDropboxComponente(
      {this.titulo,
      this.hintTexto,
      this.dropdownValue,
      this.items,
      this.height,
      this.onchanged});

  @override
  _CardDropboxComponenteState createState() => _CardDropboxComponenteState();
}

class _CardDropboxComponenteState extends State<CardDropboxComponente> {
  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: Text(
            widget.titulo,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18 * MediaQuery.of(context).textScaleFactor),
          ),
        ),
        Container(
          width: tamanho.width * 0.87,
          height: widget.height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(9.5),
                  bottomLeft: Radius.circular(9.5),
                  topLeft: Radius.circular(0)),
              border: Border.all(color: Colors.blueGrey)),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: DropdownButton<String>(
              hint: Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Text(
                  widget.hintTexto,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13 * MediaQuery.of(context).textScaleFactor),
                ),
              ),
              value: widget.dropdownValue,
              icon: Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_downward)),
                ),
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12 * MediaQuery.of(context).textScaleFactor),
              underline: Container(
                height: 50,
                color: Colors.transparent,
              ),
              onChanged: widget.onchanged,
              items: widget.items
                  .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                fontSize: 15 *
                                    MediaQuery.of(context).textScaleFactor)),
                      ))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
