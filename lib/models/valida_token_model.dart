class ValidaTokenModel {
  String insCToken;

  ValidaTokenModel({
    this.insCToken,
  });

  ValidaTokenModel.fromJson(Map<String, dynamic> json) {
    insCToken = json['ins_c_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ins_c_token'] = this.insCToken;

    return data;
  }
}
