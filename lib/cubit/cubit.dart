import 'dart:convert';
import 'dart:io';

import 'package:booking_appointments_doctor/cubit/app_states.dart';
import 'package:booking_appointments_doctor/models/doctors.dart';
import 'package:booking_appointments_doctor/models/speciality_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<BlocAppStatus<SpecialityModel>> {
  AppCubit() : super(BlocAppStatus(status: States.idle));

  static AppCubit get(context) => BlocProvider.of(context);

  // get all specialities

  Future<List<SpecialityModel>> emitGetAllSpecialities() async {
    var dio = Dio();
    var response = await dio.request(
      'https://masoudozel-001-site1.ktempurl.com/api/Patient/GetSpeciality',
      options: Options(
        method: 'GET',
      ),
    );
    if (response.statusCode == 200) {
      List<SpecialityModel> specialities = [];
      response.data.forEach((speciality) {
        specialities.add(SpecialityModel.fromJson(speciality));
      });
      return specialities;
    } else {
      print(response.statusMessage);
      return [];
    }
  }

  // get all doctors
  Future<List<DoctorsModel>> emitGetAllDoctors() async {
    var dio = Dio();
    var response = await dio.request(
      'https://masoudozel-001-site1.ktempurl.com/api/Doctor/GetAllDoctors',
      options: Options(
        method: 'GET',
      ),
    );
    if (response.statusCode == 200) {
      List<DoctorsModel> doctorsModel = [];
      response.data.forEach((doctor) {
        doctorsModel.add(DoctorsModel.fromJson(doctor));
      });
      return doctorsModel;
    } else {
      print(response.statusMessage);
      return [];
    }
  }

  // get all doctors by speciality
  Future<List<String>> emitGetDatesOfDoctors(String doctorId) async {
    var dio = Dio();
    try {
      var response = await dio.get(
        'https://masoudozel-001-site1.ktempurl.com/api/Patient/GetDateAvailability/$doctorId',
      );
      if (response.statusCode == 200) {
        if (response.data is List) {
          List<String> dates = (response.data as List).map((item) {
            try {
              if (item is Map<String, dynamic> && item.containsKey('date')) {
                var date = DateTime.parse(item['date'].toString());
                return date.toLocal().toString().split(' ')[0];
              } else if (item is String) {
                var date = DateTime.parse(item);
                return date.toLocal().toString().split(' ')[0];
              } else {
                throw FormatException('Unexpected item format: $item');
              }
            } catch (e) {
              print('Error parsing date: $e');
              return '';
            }
          }).toList();
          return dates.where((date) => date.isNotEmpty).toList();
        } else {
          throw FormatException('Unexpected data format: ${response.data}');
        }
      } else {
        throw HttpException('Error: ${response.statusMessage}');
      }
    } catch (e) {
      print('Request error: $e');
      return [];
    }
  }

  // get all times of doctors
  Future<List<String>> emitGetTimesOfDoctors(
      String doctorId, String date) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({
      "doctorId": doctorId,
      "date": date,
      "timeSlots": [date]
    });
    var dio = Dio();
    var response = await dio.request(
      'https://masoudozel-001-site1.ktempurl.com/api/Patient/GetTimeSlotAvailability',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      if (response.data is List) {
        return (response.data as List).map((item) => item.toString()).toList();
      } else {
        throw FormatException('Unexpected data format: ${response.data}');
      }
    } else {
      throw HttpException('Error: ${response.statusMessage}');
    }
  }
}
