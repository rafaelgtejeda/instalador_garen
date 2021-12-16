import 'dart:convert';

ProductModel productFromJson(String str) => ProductModel.fromJson(
  json.decode(str),
);

List<ProductModel> productsFromJson(dynamic str) => List<ProductModel>.from(
  (str).map(
    (x) => ProductModel.fromJson(x),
  ),
);

class ProductModel {

  int id;
  String name;
  String type;
  String feature;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String permalink;
  int parentId;
  List<Images> images;
  List<Attributes> attributes;
  List<Categories> categories;
  List<Downloads> downloads;

  ProductModel({
    this.id,
    this.name,
    this.type,
    this.feature,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.permalink,
    this.parentId,
    this.images,
    this.attributes,
    this.categories,
    this.downloads,
  });

  ProductModel.fromJson(Map<String, dynamic> json){

    id = json['id'];
    name = json['name'];
    type = json['type'];
    feature = json['feature'];
    description = json['description'];
    shortDescription = json['shortdescription'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    permalink = json['permalink'];
    parentId = json['parent_id'];

    
    if (json['images'] != null) {
      images = new List<Images>.empty(growable: true);
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }

    if (json['attributes'] != null) {
      attributes = new List<Attributes>.empty(growable: true);
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }

    if (json['categories'] != null) {
      categories = new List<Categories>.empty(growable: true);
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }

    if (json['downloads'] != null) {
      downloads = new List<Downloads>();
      json['downloads'].forEach((v) {
        downloads.add(new Downloads.fromJson(v));
      });
    }

  }
  
}

class Images {

  int id;
  String dateCreated;
  String dateCreatedGmt;
  String dateModifiedGmt;
  String dateModified;
  String src;
  String name;
  String alt;

  Images({
      this.id,
      this.dateCreated,
      this.dateCreatedGmt,
      this.dateModifiedGmt,
      this.dateModified,
      this.src,
      this.name,
      this.alt
    });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModifiedGmt = json['date_modified_gmt'];
    dateModified = json['date_modified'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    return data;
  }

}

class Attributes {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  Attributes(
      {this.id,
      this.name,
      this.position,
      this.visible,
      this.variation,
      this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['options'] = this.options;
    return data;
  }
}

class Categories {
  int id;
  String name;
 
  Categories(
      {this.id,
      this.name,
     });

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Downloads {
  String id;
  String name;
  String file;

  Downloads({this.id, this.name, this.file});

  Downloads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file'] = this.file;
    return data;
  }
}