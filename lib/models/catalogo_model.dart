class CatalogoModel {
  int id;
  String slug;
  String type;
  String title;
  String link;
  String categoriaProd;
  List<String> finalidades;
  String cod;
  String desc;
  String imagens;
  String manual;
  String dimensoes;
  String visaoExplodida;
  String especificaesTcnicas;
  String featuredImgSrc;

  CatalogoModel(
      {this.id,
      this.slug,
      this.type,
      this.title,
      this.link,
      this.categoriaProd,
      this.finalidades,
      this.cod,
      this.desc,
      this.imagens,
      this.manual,
      this.dimensoes,
      this.visaoExplodida,
      this.especificaesTcnicas,
      this.featuredImgSrc});

  CatalogoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    type = json['type'];
    title = json['title'];
    link = json['link'];
    categoriaProd = json['categoria_prod'];
    finalidades = json['finalidades'].cast<String>();
    cod = json['cod'];
    desc = json['desc'];
    imagens = json['imagens'];
    manual = json['manual'];
    dimensoes = json['dimensoes'];
    visaoExplodida = json['visao_explodida'];
    especificaesTcnicas = json['especificaes_tcnicas'];
    featuredImgSrc = json['featured_img_src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['title'] = this.title;
    data['link'] = this.link;
    data['categoria_prod'] = this.categoriaProd;
    data['finalidades'] = this.finalidades;
    data['cod'] = this.cod;
    data['desc'] = this.desc;
    data['imagens'] = this.imagens;
    data['manual'] = this.manual;
    data['dimensoes'] = this.dimensoes;
    data['visao_explodida'] = this.visaoExplodida;
    data['especificaes_tcnicas'] = this.especificaesTcnicas;
    data['featured_img_src'] = this.featuredImgSrc;
    return data;
  }
}
