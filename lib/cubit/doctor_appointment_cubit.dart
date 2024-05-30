// import 'package:bloc/bloc.dart';
// import 'package:booking_appointments_doctor/models/user.dart';
//
// import '../repo/doctor_appointment_repo.dart';
// import 'doctor_appointment_state.dart';
//
// class DoctorAppointmentCubit extends Cubit<DoctorAppointmentStates> {
//   final DoctorAppointmentRepo doctorAppointmentRepo;
//   DoctorAppointmentCubit(this.doctorAppointmentRepo)
//       : super(DoctorAppointmentInitial());
//   UserModel? userModel;
//   void login(String email, String password) {
//     emit(DoctorAppointmentLoading());
//     doctorAppointmentRepo.getUser(email, password).then((value) {
//       userModel = value;
//       emit(DoctorAppointmentSuccess());
//     }).catchError((error) {
//       print(error.toString());
//       emit(DoctorAppointmentError());
//     });
//   }
// }
