class BannerModel {
  int banNCodigo;
  String banBAtivo;
  String banCImg;
  String banCLink;
  int banNOrdem;
  String banCTitle;
  String banCImgUrl;
  String banBSalvo;

  BannerModel(
      {this.banNCodigo,
      this.banBAtivo,
      this.banCImg,
      this.banCLink,
      this.banNOrdem,
      this.banCTitle,
      this.banCImgUrl,
      this.banBSalvo});

  BannerModel.fromJson(Map<String, dynamic> json) {
    banNCodigo = json['ban_n_codigo'];
    banBAtivo = json['ban_b_ativo'];
    banCImg = json['ban_c_img'];
    banCLink = json['ban_c_link'];
    banNOrdem = json['ban_n_ordem'];
    banCTitle = json['ban_c_title'];
    banCImgUrl = json['ban_c_imgUrl'];
    banBSalvo = json['ban_b_salvo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ban_n_codigo'] = this.banNCodigo;
    data['ban_b_ativo'] = this.banBAtivo;
    data['ban_c_img'] = this.banCImg;
    data['ban_c_link'] = this.banCLink;
    data['ban_n_ordem'] = this.banNOrdem;
    data['ban_c_title'] = this.banCTitle;
    data['ban_c_imgUrl'] = this.banCImgUrl;
    data['ban_b_salvo'] = this.banBSalvo;
    return data;
  }
}
