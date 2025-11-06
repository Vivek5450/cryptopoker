class LoginResponseModel {
  int? code;
  Data? data;
  String? message;

  LoginResponseModel({this.code, this.data, this.message});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  String? username;
  int? userType;
  String? email;
  String? phone;
  String? avatar;
  String? frame;
  String? signature;
  String? token;
  String? tokenExpiresAt;
  String? refreshToken;
  String? refreshTokenExpiresAt;
  String? country;
  String? createdAt;

  Data(
      {this.userId,
        this.username,
        this.userType,
        this.email,
        this.phone,
        this.avatar,
        this.frame,
        this.signature,
        this.token,
        this.tokenExpiresAt,
        this.refreshToken,
        this.refreshTokenExpiresAt,
        this.country,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    userType = json['user_type'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    frame = json['frame'];
    signature = json['signature'];
    token = json['token'];
    tokenExpiresAt = json['token_expires_at'];
    refreshToken = json['refresh_token'];
    refreshTokenExpiresAt = json['refresh_token_expires_at'];
    country = json['country'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['frame'] = this.frame;
    data['signature'] = this.signature;
    data['token'] = this.token;
    data['token_expires_at'] = this.tokenExpiresAt;
    data['refresh_token'] = this.refreshToken;
    data['refresh_token_expires_at'] = this.refreshTokenExpiresAt;
    data['country'] = this.country;
    data['created_at'] = this.createdAt;
    return data;
  }
}