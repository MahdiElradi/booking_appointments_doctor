class DoctorModel {
  int? doctorId;
  bool? isAdmin;
  bool? isFirstLogin;

  DoctorModel({
    this.doctorId,
    this.isAdmin,
    this.isFirstLogin,
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    isAdmin = json['isAdmin'];
    isFirstLogin = json['isFirstLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['isAdmin'] = isAdmin;
    data['isFirstLogin'] = isFirstLogin;
    return data;
  }
}
