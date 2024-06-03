class UserModel {
  int? patientId;
  String? patientName;

  UserModel({
    this.patientId,
    this.patientName,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    patientName = json['patientName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientId'] = patientId;
    data['patientName'] = patientName;

    return data;
  }
}
