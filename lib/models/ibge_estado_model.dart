import 'dart:convert';

class IgbeEstadoModel {
  int id;
  String sigla;
  String nome;

  IgbeEstadoModel({this.id, this.nome, this.sigla});

  factory IgbeEstadoModel.fromJson(String str) =>
      IgbeEstadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IgbeEstadoModel.fromMap(Map<String, dynamic> json) => IgbeEstadoModel(
        id: json["id"],
        sigla: json["sigla"],
        nome: json["nome"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sigla": sigla,
        "nome": nome,
      };
}
