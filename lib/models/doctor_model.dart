class DoctorModel {
  int? id;
  String? doctorName;
  String? speciality;

  DoctorModel({this.id, this.doctorName, this.speciality});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorName = json['doctorName'];
    speciality = json['speciality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['doctorName'] = doctorName;
    data['speciality'] = speciality;
    return data;
  }
}
