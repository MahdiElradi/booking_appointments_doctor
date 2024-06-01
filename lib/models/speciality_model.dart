class SpecialityModel {
  int? id;
  String? doctorName;
  String? speciality;

  SpecialityModel({this.id, this.doctorName, this.speciality});

  SpecialityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorName = json['doctorName'];
    speciality = json['speciality'];
  }

  static List<SpecialityModel> fromJsonList(List<dynamic> list) {
    return list.isEmpty
        ? []
        : list.map((e) => SpecialityModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctorName'] = doctorName;
    data['speciality'] = speciality;
    return data;
  }
}
