class BrandModel {
  List<BrandModel> _brands;
}

class Brand {
  int _id;
  String _name;
  int _position;
  int _status;
  int _ranking;
  String _createdAt;
  String _updatedAt;
  String _image;

  Brand(
      {int id,
      String name,
      int position,
      int status,
      int ranking,
      String createdAt,
      String updatedAt,
      String image}) {
    this._id = id;
    this._name = name;
    this._position = position;
    this._status = status;
    this._ranking = ranking;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._image = image;
  }

  String get image => _image;

  String get updatedAt => _updatedAt;

  String get createdAt => _createdAt;

  int get ranking => _ranking;

  int get status => _status;

  int get position => _position;

  String get name => _name;

  int get id => _id;

  Brand.fromJson(Map<String, dynamic> json) {
    this._id = json['id'];
    this._name = json['name'];
    this._position = json['position'];
    this._status = json['status'];
    this._ranking = json['ranking'];
    this._createdAt = json['created_at'];
    this._updatedAt = json['updated_at'];
    this._image = json['image'];
  }

  @override
  String toString() {
    return 'Brand{_id: $_id, _name: $_name, _status: $_status, _ranking: $_ranking, _createdAt: $_createdAt, _image: $_image}';
  }
}
