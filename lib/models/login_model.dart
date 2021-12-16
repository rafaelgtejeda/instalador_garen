class LoginModel {
  String insNCodigo;
  String insCEmail;
  String insBGarenNewuser;
  String insBGarenProgram;
  String insCImage;
  String insCNome;
  String insCPassword;
  String insCTelefone;
  String insCRg;
  String insCCpf;
  String insCCep;
  String insCEndereco;
  String insCNumero;
  String insCUid;
  String insCidNCodigo;
  String insEstNCodigo;
  String insCKey;
  String insFpiNCodigo;
  String insBOnline;
  String insCToken;

  LoginModel(
      {this.insNCodigo,
      this.insCEmail,
      this.insBGarenNewuser,
      this.insBGarenProgram,
      this.insCImage,
      this.insCNome,
      this.insCPassword,
      this.insCTelefone,
      this.insCRg,
      this.insCCpf,
      this.insCCep,
      this.insCEndereco,
      this.insCNumero,
      this.insCUid,
      this.insCidNCodigo,
      this.insEstNCodigo,
      this.insCKey,
      this.insFpiNCodigo,
      this.insBOnline,
      this.insCToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    insNCodigo = json['ins_n_codigo'];
    insCEmail = json['ins_c_email'];
    insBGarenNewuser = json['ins_b_garen_newuser'];
    insBGarenProgram = json['ins_b_garen_program'];
    insCImage = json['ins_c_image'];
    insCNome = json['ins_c_nome'];
    insCPassword = json['ins_c_password'];
    insCTelefone = json['ins_c_telefone'];
    insCRg = json['ins_c_rg'];
    insCCpf = json['ins_c_cpf'];
    insCCep = json['ins_c_cep'];
    insCEndereco = json['ins_c_endereco'];
    insCNumero = json['ins_c_numero'];
    insCUid = json['ins_c_uid'];
    insCidNCodigo = json['ins_cid_n_codigo'];
    insEstNCodigo = json['ins_est_n_codigo'];
    insCKey = json['ins_c_key'];
    insFpiNCodigo = json['ins_fpi_n_codigo'];
    insBOnline = json['ins_b_online'];
    insCToken = json['ins_c_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ins_n_codigo'] = this.insNCodigo;
    data['ins_c_email'] = this.insCEmail;
    data['ins_b_garen_newuser'] = this.insBGarenNewuser;
    data['ins_b_garen_program'] = this.insBGarenProgram;
    data['ins_c_image'] = this.insCImage;
    data['ins_c_nome'] = this.insCNome;
    data['ins_c_password'] = this.insCPassword;
    data['ins_c_telefone'] = this.insCTelefone;
    data['ins_c_rg'] = this.insCRg;
    data['ins_c_cpf'] = this.insCCpf;
    data['ins_c_cep'] = this.insCCep;
    data['ins_c_endereco'] = this.insCEndereco;
    data['ins_c_numero'] = this.insCNumero;
    data['ins_c_uid'] = this.insCUid;
    data['ins_cid_n_codigo'] = this.insCidNCodigo;
    data['ins_est_n_codigo'] = this.insEstNCodigo;
    data['ins_c_key'] = this.insCKey;
    data['ins_fpi_n_codigo'] = this.insFpiNCodigo;
    data['ins_b_online'] = this.insBOnline;
    data['ins_c_token'] = this.insCToken;
    return data;
  }
}
