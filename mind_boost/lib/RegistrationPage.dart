import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _birthdayController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime? _selectedDate;

  String _name = '';
  String _phoneNumber = '';
  String _nicNumber = '';
  bool _isUser = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_isUser) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserQuestionnairePage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CounselorVerificationPage()),
        );
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate!);
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      DateTime now = DateTime.now();
      int age = now.year - _selectedDate!.year;

      if (now.month < _selectedDate!.month ||
          (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
        age--;
      }

      _ageController.text = age.toString();
    }
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                //controller: _nicNumberController,
                decoration: InputDecoration(
                  labelText: 'NIC Number',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIC number';
                  } else if (!_validateNicNumber(value)) {
                    return 'Invalid NIC number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nicNumber = value!;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('User'),
                  Switch(
                    value: _isUser,
                    onChanged: (value) {
                      setState(() {
                        _isUser = value;
                      });
                    },
                  ),
                  Text('Counselor'),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _validateNicNumber(String nicNumber) {
  RegExp regex = RegExp(r'^\d{9}[vVxX]$');
  return regex.hasMatch(nicNumber);
}
