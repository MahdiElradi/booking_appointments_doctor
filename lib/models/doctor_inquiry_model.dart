class DoctorInquiryModel {
  int id;
  int patientId;
  int doctorId;
  DateTime appointmentDate;
  String appointmentTime;
  String appointmentStatus;

  DoctorInquiryModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentStatus,
  });

  static List<DoctorInquiryModel> fromJsonList(List<dynamic> list) {
    return list.isEmpty
        ? []
        : list.map((e) => DoctorInquiryModel.fromJson(e)).toList();
  }

  factory DoctorInquiryModel.fromJson(Map<String, dynamic> json) =>
      DoctorInquiryModel(
        id: json["id"],
        patientId: json["patientId"],
        doctorId: json["doctorId"],
        appointmentDate: DateTime.parse(json["appointmentDate"]),
        appointmentTime: json["appointmentTime"],
        appointmentStatus: json["appointmentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patientId": patientId,
        "doctorId": doctorId,
        "appointmentDate":
            "${appointmentDate.year.toString().padLeft(4, '0')}-${appointmentDate.month.toString().padLeft(2, '0')}-${appointmentDate.day.toString().padLeft(2, '0')}",
        "appointmentTime": appointmentTime,
        "appointmentStatus": appointmentStatus,
      };
}
