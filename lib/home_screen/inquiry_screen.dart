import 'package:flutter/material.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
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
    // Add more appointments here
  ];

  String _searchName = '';
  String _searchPhone = '';

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
            icon: const Icon(Icons.logout),
            onPressed: () {},
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
                      icon: Icon(Icons.search, color: Colors.white),
                      labelText: 'Search by Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone, color: Colors.white),
                      labelText: 'Search by Phone',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchPhone = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredAppointments().length,
                      itemBuilder: (context, index) {
                        final appointment = _filteredAppointments()[index];
                        return Card(
                          color: Colors.white.withOpacity(0.8),
                          child: ListTile(
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
      final phoneMatch = appointment['phone']!.contains(_searchPhone);
      return nameMatch && phoneMatch;
    }).toList();
  }
}
