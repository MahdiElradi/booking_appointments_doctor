import 'package:booking_appointments_doctor/login/registeration_patient.dart';
import 'package:flutter/material.dart';

import '../cache_helper.dart';
import '../cubit/cubit.dart';
import '../home_screen/book_appointment_screen.dart';

class PatientLoginScreen extends StatefulWidget {
  const PatientLoginScreen({super.key});

  @override
  State<PatientLoginScreen> createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = false;

  void _login() async {
    setState(() {
      isLogin = true;
    });

    try {
      final value = await AppCubit.get(context)
          .emitLoginPatient(_usernameController.text, _passwordController.text);

      // Save data to SharedPreferences
      await CacheHelper.saveData(key: 'patientId', value: value.patientId);

      // Navigate to BookingScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BookingScreen(),
        ),
      );

      print('Login successful');
      print('User ID: ${value.patientId}');
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLogin = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Patient',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person, color: Colors.white),
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.white),
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
                            child: isLogin
                                ? const CircularProgressIndicator()
                                : const Text('Login'),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationPatient()),
                              );
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      ],
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
