class UserModel {
  String id;
  String name;
  String user;
  String password;
  int departmentID;

  UserModel({required this.id, required this.name, required this.user, required this.password, required this.departmentID});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      user: json['user'],
      password: json['password'],
      departmentID: json['departmentID'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user'] = user;
    data['password'] = password;
    data['departmentID'] = departmentID;
    return data;
  }
}
