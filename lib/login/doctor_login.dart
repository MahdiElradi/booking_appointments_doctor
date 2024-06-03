import 'package:flutter/material.dart';

import '../cache_helper.dart';
import '../cubit/cubit.dart';
import '../home_screen/inquiry_screen.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
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
          .emitLoginDoctor(_usernameController.text, _passwordController.text);
      print('Received value: $value');

      // Ensure CacheHelper is initialized
      await CacheHelper.init();
      print('CacheHelper initialized');

      // Save data to SharedPreferences
      await CacheHelper.saveData(key: 'doctorId', value: value.doctorId);
      print('Saved data: ${value.doctorId}');

      // Navigate to InquiryScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InquiryScreen(),
        ),
      );

      print('Login successful');
      print('Doctor ID: ${value.doctorId}');
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
          'Login Doctor',
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
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: isLogin
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
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
