class DoctorsModel {
  int? id;
  String? doctorName;
  String? speciality;

  DoctorsModel({
    this.id,
    this.doctorName,
    this.speciality,
  });

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorName = json['doctorName'];
    speciality = json['speciality'];
  }

  // static List<DoctorsModel> fromJsonList(List list) {
  //   return list.map((item) => DoctorsModel.fromJson(item)).toList();
  // }

  static List<DoctorsModel> fromJsonList(List<dynamic> list) {
    return list.isEmpty
        ? []
        : list.map((e) => DoctorsModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctorName'] = doctorName;
    data['speciality'] = speciality;
    return data;
  }
}
