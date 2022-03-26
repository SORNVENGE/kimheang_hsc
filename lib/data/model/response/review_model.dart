class ReviewModel {
  int _id;
  int _productId;
  int _userId;
  String _comment;
  List<String> _attachment;
  int _rating;
  String _createdAt;
  String _updatedAt;
  int _orderId;
  Customer _customer;

  ReviewModel(
      {int id,
        int productId,
        int userId,
        String comment,
        List<String> attachment,
        int rating,
        String createdAt,
        String updatedAt,
        int orderId,
        Customer customer}) {
    this._id = id;
    this._productId = productId;
    this._userId = userId;
    this._comment = comment;
    this._attachment = attachment;
    this._rating = rating;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._orderId = orderId;
    this._customer = customer;
  }

  int get id => _id;
  int get productId => _productId;
  int get userId => _userId;
  String get comment => _comment;
  List<String> get attachment => _attachment;
  int get rating => _rating;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get orderId => _orderId;
  Customer get customer => _customer;

  ReviewModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _userId = json['user_id'];
    _comment = json['comment'];
    _attachment = json['attachment'].cast<String>();
    _rating = json['rating'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _orderId = json['order_id'];
    _customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['user_id'] = this._userId;
    data['comment'] = this._comment;
    data['attachment'] = this._attachment;
    data['rating'] = this._rating;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['order_id'] = this._orderId;
    if (this._customer != null) {
      data['customer'] = this._customer.toJson();
    }
    return data;
  }
}

class Customer {
  int _id;
  String _fName;
  String _lName;
  String _email;
  String _image;
  int _isPhoneVerified;
  String _emailVerifiedAt;
  String _createdAt;
  String _updatedAt;
  String _emailVerificationToken;
  String _phone;
  String _cmFirebaseToken;

  Customer(
      {int id,
        String fName,
        String lName,
        String email,
        String image,
        int isPhoneVerified,
        String emailVerifiedAt,
        String createdAt,
        String updatedAt,
        String emailVerificationToken,
        String phone,
        String cmFirebaseToken}) {
    this._id = id;
    this._fName = fName;
    this._lName = lName;
    this._email = email;
    this._image = image;
    this._isPhoneVerified = isPhoneVerified;
    this._emailVerifiedAt = emailVerifiedAt;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._emailVerificationToken = emailVerificationToken;
    this._phone = phone;
    this._cmFirebaseToken = cmFirebaseToken;
  }

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get email => _email;
  String get image => _image;
  int get isPhoneVerified => _isPhoneVerified;
  String get emailVerifiedAt => _emailVerifiedAt;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get emailVerificationToken => _emailVerificationToken;
  String get phone => _phone;
  String get cmFirebaseToken => _cmFirebaseToken;

  Customer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _email = json['email'];
    _image = json['image'];
    _isPhoneVerified = json['is_phone_verified'];
    _emailVerifiedAt = json['email_verified_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _emailVerificationToken = json['email_verification_token'];
    _phone = json['phone'];
    _cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['email'] = this._email;
    data['image'] = this._image;
    data['is_phone_verified'] = this._isPhoneVerified;
    data['email_verified_at'] = this._emailVerifiedAt;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['email_verification_token'] = this._emailVerificationToken;
    data['phone'] = this._phone;
    data['cm_firebase_token'] = this._cmFirebaseToken;
    return data;
  }
}
