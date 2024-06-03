import 'package:booking_appointments_doctor/models/doctors.dart';
import 'package:booking_appointments_doctor/models/speciality_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cache_helper.dart';
import '../cubit/cubit.dart';
import '../login/patient_login.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final _dateFormatter = DateFormat('yyyy-MM-dd');
  String? _selectedDate;

  String? _selectedTime;

  String? _selectedDoctor;
  String? _selectedSpeciality;

  final _formKey = GlobalKey<FormState>();

  // final List<String> _dates = ['2024-06-01', '2024-06-02', '2024-06-03'];
  List<String> dates = [];
  // final List<String> _times = ['10:00 AM', '11:00 AM', '12:00 PM'];
  List<String> _times = [];
  // final List<String> _speciality = [];

  // final List<String> _doctor = [];

  late List<SpecialityModel> specialityModel = [];
  late List<DoctorsModel> doctorsModel = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getSpecialitiesList();
      getDoctorsList();
      getTimesOfDoctors('1', '2024-06-01');
    });
  }

  Future<void> getSpecialitiesList() async {
    setState(() {
      loading = true;
    });

    // specialities
    if (!mounted) return;
    specialityModel =
        await BlocProvider.of<AppCubit>(context).emitGetAllSpecialities();
    if (mounted) {
      setState(() {
        loading = false;
      });
    }

    // specialities
    if (!mounted) return;
    doctorsModel = await BlocProvider.of<AppCubit>(context).emitGetAllDoctors();
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> getDoctorsList() async {
    try {
      setState(() {
        loading = true;
      });
      if (!mounted) return;
      doctorsModel =
          await BlocProvider.of<AppCubit>(context).emitGetAllDoctors();
      // if (doctorsModel != null && doctorsModel.isNotEmpty) {
      //   String doctorId = doctorsModel[0].id.toString();
      //   getDatesOfDoctors(doctorId);
      // }
    } catch (e) {
      print('Error getting doctors list: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> getDatesOfDoctors(doctorId) async {
    try {
      setState(() {
        loading = true;
      });
      if (!mounted) return;
      dates.clear();
      dates = await BlocProvider.of<AppCubit>(context)
          .emitGetDatesOfDoctors(doctorId);
    } catch (e) {
      print('Error getting dates of doctor: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> getTimesOfDoctors(doctorId, date) async {
    try {
      setState(() {
        loading = true;
      });
      if (!mounted) return;
      _times.clear();
      _times = await BlocProvider.of<AppCubit>(context)
          .emitGetTimesOfDoctors(doctorId, date);
    } catch (e) {
      print('Error getting times of doctor: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  _onSubmit() {}

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  final userName = CacheHelper.getData(key: 'userName');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade700,
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
                    builder: (context) => const PatientLoginScreen(),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person, color: Colors.white),
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone, color: Colors.white),
                        labelText: 'Phone',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateOfBirthController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        labelText: 'Date of Birth',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _dateOfBirthController.text =
                              _dateFormatter.format(date);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        labelText: 'Speciality',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedSpeciality,
                      onChanged: (String? newValue) {
                        _selectedSpeciality = newValue;
                      },
                      items: specialityModel.map<DropdownMenuItem<String>>(
                          (SpecialityModel value) {
                        return DropdownMenuItem<String>(
                          value: value.speciality,
                          child: Text(value.speciality.toString()),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        labelText: 'Doctor',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedDoctor,
                      onChanged: (String? newValue) {
                        _selectedDoctor = newValue;
                      },
                      items: doctorsModel
                          .map<DropdownMenuItem<String>>((DoctorsModel value) {
                        return DropdownMenuItem<String>(
                          value: value.doctorName,
                          child: Text(value.doctorName.toString()),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateOfBirthController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        labelText: 'Date',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _dateOfBirthController.text =
                              _dateFormatter.format(date);
                        }
                      },
                    ),
                    // DropdownButtonFormField<String>(
                    //   decoration: const InputDecoration(
                    //     icon: Icon(Icons.calendar_today, color: Colors.white),
                    //     labelText: 'Date',
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //   ),
                    //   value: _selectedDate,
                    //   onChanged: (String? newValue) {
                    //     _selectedDate = newValue;
                    //   },
                    //   items:
                    //       dates.map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.access_time, color: Colors.white),
                        labelText: 'Time',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedTime,
                      onChanged: (String? newValue) {
                        _selectedTime = newValue;
                      },
                      items:
                          _times.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Processing Data'),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
