import 'package:booking_appointments_doctor/cubit/cubit.dart';
import 'package:booking_appointments_doctor/login/doctor_login.dart';
import 'package:flutter/material.dart';

import '../cache_helper.dart';
import '../models/doctor_inquiry_model.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String _searchName = '';
  bool isLogin = false;

  List<TotalAppointmentsModel> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final appointments = await AppCubit.get(context).getAllAppointments(11);
    setState(() {
      _appointments = appointments;
    });
  }

  List<TotalAppointmentsModel> _filteredAppointments() {
    if (_searchName.isEmpty) return _appointments;
    return _appointments.where((appointment) {
      if (appointment.doctorName == null) return false;
      final nameMatch = appointment.doctorName
          ?.toLowerCase()
          .contains(_searchName.toLowerCase());
      return nameMatch ?? false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inquiry Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Row(
              children: [
                Text('Logout',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(width: 5),
                Icon(Icons.logout, size: 20, color: Colors.white),
              ],
            ),
            onPressed: () {
              CacheHelper.removeData(key: 'id').then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorLoginScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/005/245/306/non_2x/double-exposure-of-success-smart-medical-doctor-working-with-abstract-blurry-bokeh-background-as-concept-free-photo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search by Name',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredAppointments().length,
                      itemBuilder: (context, index) {
                        final appointment = _filteredAppointments()[index];
                        return buildTotalAppointmentsCard(appointment, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card buildTotalAppointmentsCard(
      TotalAppointmentsModel appointment, BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Patient Name: ${appointment.patientName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doctor Name: ${appointment.doctorName}'),
                Text('Created Date: ${appointment.createdDate}'),
                Text('Selected Date: ${appointment.selectedDate}'),
                Text('Time Slot: ${appointment.timeSlot}'),
              ],
            ),
          ),
          if (appointment.status != 1) // Add this line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.all(5), // Add margin
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MaterialButton(
                      child: const Text('Accept',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await AppCubit.get(context).updateDoctorStatus("0");
                        // setState(() {
                        //   appointment.status = 1;
                        // });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MaterialButton(
                      child: const Text('Reject',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        // await AppCubit.get(context)
                        //     .updateDoctorStatus("1");
                        // setState(() {
                        //   appointment.status = 1;
                        // });
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

// List<TotalAppointmentsModel> _filteredAppointments() {
//   return _appointments.where((appointment) {
//     final nameMatch = appointment['name']!
//         .toLowerCase()
//         .contains(_searchName.toLowerCase());
//     // final phoneMatch = appointment['phone']!.contains(_searchPhone);
//     return nameMatch;
//     // && phoneMatch;
//   }).toList();
// }
}
