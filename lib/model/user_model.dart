class UserModel {

  int? user_id;
  String user_name;
  String user_email ;
  String user_phone;
  String user_pass;

  UserModel({required this.user_name,required this.user_email, required this.user_phone, required this.user_pass,this.user_id});

  factory UserModel.fromJson(Map<String,dynamic> json) => UserModel
    (user_name: json['user_name'], user_email: json['user_email'], user_phone: json['user_phone'], user_pass: json['user_pass'],user_id: json['user_id']);

  Map<String,dynamic> toMap() => {
    'user_id' : user_id,
    'user_name' : user_name,
    'user_email' : user_email,
    'user_phone' : user_phone,
    'user_pass' : user_pass
  };
}