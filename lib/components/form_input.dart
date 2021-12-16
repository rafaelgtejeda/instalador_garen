import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatefulWidget {
  const FormInput(
      {this.dica,
      this.icone,
      this.onchanged,
      this.inputFormatters,
      this.keyboardType,
      this.validator,
      @required this.tamanho,
      this.textInputAction,
      this.enable,
      @required this.controller});

  final String dica;
  final bool enable;
  final Function(String) onchanged;
  final Function(String) validator;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final IconData icone;
  final Size tamanho;
  final TextInputAction textInputAction;

  @override
  _FormInputState createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.tamanho.width * 0.04,
          right: widget.tamanho.width * 0.04,
          bottom: 10),
      child: TextFormField(
        enabled: widget.enable,
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        onSaved: (val) => setState(() => widget.controller.text = val),
        onChanged: widget.onchanged,
        validator: widget.validator,
        style: new TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: widget.dica,
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Icon(widget.icone, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
        ),
        keyboardType: widget.keyboardType ?? TextInputType.text,
        autocorrect: false,
      ),
    );
  }
}
