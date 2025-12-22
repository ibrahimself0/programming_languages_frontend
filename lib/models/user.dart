class User {
   String? phoneNumber; // max: 15, unique
   String? password; // min: 8, confirmed
   String? firstName; // max: 255
   String? lastName; // max: 255
   DateTime dateOfBirth; // required date
   String? role;
   String? token;// max: 50

  User({
    required this.phoneNumber,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.role,
    required this.token,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phoneNumber: json["user"]["phoneNumber"] ?? '',
      password: json["user"]["password"] ?? '',
      firstName: json["user"]["firstName"] ?? '',
      lastName: json["user"]["lastName"] ?? '',
      dateOfBirth: DateTime.parse(json["user"]["dateOfBirth"]),
      role: json["user"]["role"] ?? '',
      token: json["user"]["token"] ?? '',
    );
  }

}

