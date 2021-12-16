class AtualizaSenhaModel {
  String insCPassword;

  AtualizaSenhaModel({
    this.insCPassword,
  });

  AtualizaSenhaModel.fromJson(Map<String, dynamic> json) {
    insCPassword = json['ins_c_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ins_c_password'] = this.insCPassword;

    return data;
  }
}
