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
  final TextEditingController _selectedDateController = TextEditingController();

  final _dateFormatter = DateFormat('yyyy-MM-dd');
  String? _selectedDate;

  String? _selectedTime;

  String? _selectedDoctor;
  String? _selectedSpeciality;

  final _formKey = GlobalKey<FormState>();

  List<String> dates = [];

  List<String> _times = [];

  late List<SpecialityModel> specialityModel = [];
  late List<DoctorsModel> doctorsModel = [];
  DoctorsModel? docModel;
  bool loading = false;
  bool _loading = false;

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
      for (var doctor in doctorsModel) {
        if (doctor.doctorName != null && doctor.id != null) {
          doctorNameToId[doctor.doctorName!] = doctor.id!;
        }
      }
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

  Map<String, int> doctorNameToId = {};

  Future<void> _onSubmit() async {
    setState(() {
      _loading = true;
    });
    final date = _selectedDate.toString();
    final time = _selectedTime.toString();
    final doctor = _selectedDoctor;
    final doctorId = doctorNameToId[doctor];
    final patientId = await CacheHelper.getData(key: 'patientId');

    if (doctorId != null && patientId != null && date != null && time != null) {
      await AppCubit.get(context)
          .bookAppointment(
        doctorId,
        patientId,
        date,
        time,
      )
          .then((value) {
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _selectedDoctor = null;
          _selectedSpeciality = null;
          _nameController.clear();
          _loading = false;
        });
        print('Appointment booked');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment successfully applied.',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
      }).onError((error, stackTrace) {
        print('Error booking appointment: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error booking appointment',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selectedDateController.dispose();
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a speciality';
                        }
                        return null;
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a doctor';
                        }
                        return null;
                      },
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
                      controller: _selectedDateController
                        ..text = _selectedDate ?? '',
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        labelText: 'Date',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = _dateFormatter.format(date);
                          });
                          getDatesOfDoctors(_selectedDoctor);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.access_time, color: Colors.white),
                        labelText: 'Time',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a time';
                        }
                        return null;
                      },
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
                      child: _loading
                          ? CircularProgressIndicator()
                          : const Text('Submit'),
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
