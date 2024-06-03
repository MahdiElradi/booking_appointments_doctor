import 'package:booking_appointments_doctor/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cache_helper.dart';
import 'cubit/cubit.dart';
import 'home_screen/book_appointment_screen.dart';
import 'home_screen/inquiry_screen.dart';
import 'login/doctor_login.dart';
import 'login/patient_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MyApp());
}

final kUserId = CacheHelper.getData(key: 'id');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
      ],
      child: MaterialApp(
        title: 'Doctor Appointment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to Doctor Appointment',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 50),
              const Text(
                'Please select your role to continue:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder(
                    future: CacheHelper.getData(key: 'patientId'),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // show a loading spinner while waiting
                      } else {
                        return InkWell(
                          onTap: () {
                            if (snapshot.data != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BookingScreen()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientLoginScreen()),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Image.network(
                                'https://m.media-amazon.com/images/I/61-Q8uNT2iL._AC_UF1000,1000_QL80_.jpg',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Patient',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: CacheHelper.getData(key: 'doctorId'),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return InkWell(
                          onTap: () {
                            if (snapshot.data != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InquiryScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorLoginScreen(),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Image.network(
                                'https://hips.hearstapps.com/hmg-prod/images/types-of-doctors-1600114658.jpg?crop=0.670xw:1.00xh;0.0553xw,0&resize=640:*',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Doctor',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
