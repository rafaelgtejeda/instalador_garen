class EsqueciSenhaModel {
  String insCEmail;

  EsqueciSenhaModel({
    this.insCEmail,
  });

  EsqueciSenhaModel.fromJson(Map<String, dynamic> json) {
    insCEmail = json['ins_c_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ins_c_email'] = this.insCEmail;

    return data;
  }
}
