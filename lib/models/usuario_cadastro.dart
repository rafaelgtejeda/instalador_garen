class UsuarioCadastroModel {
  String insNCodigo;
  String insCEmail;
  String insCPassword;
  String insCImage;
  String insCNome;
  String insCTelefone;
  String insCCEP;
  String insEstNCodigo;
  String insCidNCodigo;
  String insCUid;
  String insCKey;
  String insCToken;
  bool insBRedeSocia;
  bool insBNovoCadastro;
  String insCIdFacebook;
  String insCIdGoogle;
  String insCIdApple;

  UsuarioCadastroModel(
      {this.insNCodigo,
      this.insCEmail,
      this.insCPassword,
      this.insCImage,
      this.insCNome,
      this.insCTelefone,
      this.insCCEP,
      this.insEstNCodigo,
      this.insCidNCodigo,
      this.insCUid,
      this.insCKey,
      this.insCToken,
      this.insBRedeSocia,
      this.insBNovoCadastro,
      this.insCIdFacebook,
      this.insCIdGoogle,
      this.insCIdApple});

  UsuarioCadastroModel.fromJson(Map<String, dynamic> json) {
    insNCodigo = json['ins_n_codigo'];
    insCEmail = json['ins_c_email'];
    insCPassword = json['ins_c_password'];
    insCImage = json['ins_c_image'];
    insCNome = json['ins_c_nome'];
    insCTelefone = json['ins_c_telefone'];
    insCCEP = json['ins_c_cep'];
    insEstNCodigo = json['ins_est_n_codigo'];
    insCidNCodigo = json['ins_cid_n_codigo'];
    insCUid = json['ins_c_uid'];
    insCKey = json['ins_c_key'];
    insCToken = json['ins_c_token'];
    insBRedeSocia = json['ins_b_redeSocia'];
    insBNovoCadastro = json['ins_b_novoCadastro'];
    insCIdFacebook = json['ins_c_idFacebook'];
    insCIdGoogle = json['ins_c_idGoogle'];
    insCIdApple = json['ins_c_idApple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ins_n_codigo'] = this.insNCodigo;
    data['ins_c_email'] = this.insCEmail;
    data['ins_c_password'] = this.insCPassword;
    data['ins_c_image'] = this.insCImage;
    data['ins_c_nome'] = this.insCNome;
    data['ins_c_telefone'] = this.insCTelefone;
    data['ins_c_cep'] = this.insCCEP;
    data['ins_est_n_codigo'] = this.insEstNCodigo;
    data['ins_cid_n_codigo'] = this.insCidNCodigo;
    data['ins_c_uid'] = this.insCUid;
    data['ins_c_key'] = this.insCKey;
    data['ins_c_token'] = this.insCToken;
    data['ins_b_redeSocia'] = this.insBRedeSocia;
    data['ins_b_novoCadastro'] = this.insBNovoCadastro;
    data['ins_c_idFacebook'] = this.insCIdFacebook;
    data['ins_c_idGoogle'] = this.insCIdGoogle;
    data['ins_c_idApple'] = this.insCIdApple;
    return data;
  }
}
