class ProductVideoModel {
  int id;
  String url;
  String createdAt;
  String updatedAt;
  String image;
  String title;

  ProductVideoModel(
      {this.id,
      this.url,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.title});

  ProductVideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    return data;
  }
}
