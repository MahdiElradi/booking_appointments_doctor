class TotalAppointmentsModel {
  int? appointmentId;
  String? doctorName;
  String? patientName;
  String? createdDate;
  String? selectedDate;
  String? timeSlot;
  int? status;

  TotalAppointmentsModel(
      {this.appointmentId,
        this.doctorName,
        this.patientName,
        this.createdDate,
        this.selectedDate,
        this.timeSlot,
        this.status,});

  TotalAppointmentsModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    doctorName = json['doctorName'];
    patientName = json['patientName'];
    createdDate = json['created_Date'];
    selectedDate = json['selected_Date'];
    timeSlot = json['timeSlot'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['appointmentId'] = appointmentId;
    data['doctorName'] = doctorName;
    data['patientName'] = patientName;
    data['created_Date'] = createdDate;
    data['selected_Date'] = selectedDate;
    data['timeSlot'] = timeSlot;
    data['status'] = status;
    return data;
  }
}