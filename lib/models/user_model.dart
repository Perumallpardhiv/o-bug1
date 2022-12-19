class User {
  String userName;
  String userAadharNumber;
  String defaultLang;
  String userRole;

  User({
    required this.defaultLang,
    required this.userName,
    required this.userRole,
    required this.userAadharNumber,
  });

  factory User.fromJson(json) {
    return User(
        defaultLang: json['default_language'],
        userName: json['user_name'],
        userRole: json['user_role'],
        userAadharNumber: json['user_aadhar_number'].toString());
  }
}
