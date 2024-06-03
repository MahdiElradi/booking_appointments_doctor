import 'package:booking_appointments_doctor/cubit/cubit.dart';
import 'package:booking_appointments_doctor/login/doctor_login.dart';
import 'package:flutter/material.dart';

import '../cache_helper.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String _searchName = '';
  String _searchPhone = '';
  bool isLogin = false;
  final List<Map<String, String>> _appointments = [
    {
      'name': 'John Doe',
      'phone': '123-456-7890',
      'date': '2024-06-01',
      'time': '10:00 AM',
    },
    {
      'name': 'Jane Smith',
      'phone': '098-765-4321',
      'date': '2024-06-02',
      'time': '11:00 AM',
    },
    {
      'name': 'Jane Smith',
      'phone': '098-765-4321',
      'date': '2024-06-02',
      'time': '11:00 AM',
    },
    {
      'name': 'Jane Doe',
      'phone': '098-765-4321',
      'date': '2024-06-02',
      'time': '11:00 AM',
    },
  ];

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
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: _filteredAppointments().length,
                  //     itemBuilder: (context, index) {
                  //       final appointment = _filteredAppointments()[index];
                  //       return Card(
                  //         child: Column(
                  //           children: [
                  //             ListTile(
                  //               leading: const Icon(Icons.person),
                  //               title: Text(appointment['name']!),
                  //               subtitle: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text('Phone: ${appointment['phone']}'),
                  //                   Text('Date: ${appointment['date']}'),
                  //                   Text('Time: ${appointment['time']}'),
                  //                 ],
                  //               ),
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Expanded(
                  //                   child: Container(
                  //                     height: 25,
                  //                     margin:
                  //                         const EdgeInsets.all(5), // Add margin
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.green,
                  //                       borderRadius: BorderRadius.circular(8),
                  //                     ),
                  //                     child: MaterialButton(
                  //                       child: const Text('Accept',
                  //                           style:
                  //                               TextStyle(color: Colors.white)),
                  //                       onPressed: () {},
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Expanded(
                  //                   child: Container(
                  //                     height: 25,
                  //                     margin: const EdgeInsets.all(5),
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.red,
                  //                       borderRadius: BorderRadius.circular(8),
                  //                     ),
                  //                     child: MaterialButton(
                  //                       child: const Text('Reject',
                  //                           style:
                  //                               TextStyle(color: Colors.white)),
                  //                       onPressed: () {},
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredAppointments().length,
                      itemBuilder: (context, index) {
                        final appointment = _filteredAppointments()[index];
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(appointment['name']!),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Phone: ${appointment['phone']}'),
                                    Text('Date: ${appointment['date']}'),
                                    Text('Time: ${appointment['time']}'),
                                  ],
                                ),
                              ),
                              if (appointment['isAccepted'] !=
                                  "true") // Add this line
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 25,
                                        margin: const EdgeInsets.all(
                                            5), // Add margin
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: MaterialButton(
                                          child: const Text('Accept',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            await AppCubit.get(context)
                                                .updateDoctorStatus("0");
                                            setState(() {
                                              appointment['isAccepted'] =
                                                  "true";
                                            });
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: MaterialButton(
                                          child: const Text('Reject',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () async {
                                            await AppCubit.get(context)
                                                .updateDoctorStatus("1");
                                            setState(() {
                                              appointment['isAccepted'] =
                                                  "false";
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
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

  List<Map<String, String>> _filteredAppointments() {
    return _appointments.where((appointment) {
      final nameMatch = appointment['name']!
          .toLowerCase()
          .contains(_searchName.toLowerCase());
      // final phoneMatch = appointment['phone']!.contains(_searchPhone);
      return nameMatch;
      // && phoneMatch;
    }).toList();
  }
}
