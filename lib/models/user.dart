class UserModel {
  int? id;
  String? userName;
  String? password;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  String? address;
  String? phoneNumber;
  String? email;
  String? appointments;

  UserModel(
      {this.id,
      this.userName,
      this.password,
      this.firstName,
      this.middleName,
      this.lastName,
      this.dob,
      this.address,
      this.phoneNumber,
      this.email,
      this.appointments});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    password = json['password'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    dob = json['dob'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    appointments = json['appointments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['password'] = password;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['dob'] = dob;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['appointments'] = appointments;
    return data;
  }
}
