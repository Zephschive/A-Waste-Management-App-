import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_mangement_app/Common_widgets/Color_ext.dart';
import 'package:waste_mangement_app/Common_widgets/commonwidgets.dart';
import 'package:waste_mangement_app/pages/MyWastePage.dart';



Future<void> showAddScheduleModal(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? selectedFrequency;

  final dayController = TextEditingController();
  final timeController = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text('Add schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Day Picker
              TextFormField(
                controller: dayController,
                readOnly: true,
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (result != null) {
                    selectedDay = result.toIso8601String().split('T').first;
                    dayController.text = "${result.day}/${result.month}/${result.year}";
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Select your preferred pickup day',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (_) => selectedDay == null ? 'Please select a day' : null,
              ),
              const SizedBox(height: 16),

              // Time Picker
              TextFormField(
                controller: timeController,
                readOnly: true,
                onTap: () async {
                  final result = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (result != null) {
                    selectedTime = result;
                    timeController.text = result.format(context);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Select your preferred pickup time',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (_) => selectedTime == null ? 'Please select a time' : null,
              ),
              const SizedBox(height: 16),

              // Frequency Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select your preferred frequency',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: ['Once a week', 'Twice a week', 'Daily', 'Weekly', 'Monthly']
                    .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                    .toList(),
                onChanged: (val) {
                  selectedFrequency = val;
                },
                validator: (_) => selectedFrequency == null ? 'Please select frequency' : null,
              ),
              const SizedBox(height: 24),

              // Done Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                   final userEmail = FirebaseAuth.instance.currentUser?.email;

if (userEmail != null) {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: userEmail)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    final docId = querySnapshot.docs.first.id;

    final scheduleData = {
      'day': selectedDay,
      'time': selectedTime?.format(context),
      'frequency': selectedFrequency,
    
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({
          'schedules': FieldValue.arrayUnion([scheduleData])
        });

    // Show success
    showSnackbar("Schedule Added Successfully", WMA_Colours.greenPrimary, Colors.white, context);
    
  } else {
    // User document not found
        showSnackbar("User not found... An Error has occurred", Colors.red, Colors.white, context);
  }




                        Navigator.pop(context); // Close loading
                        Navigator.pop(context); // Close bottom sheet
                          showSnackbar("Schedule Added Successfully", WMA_Colours.greenPrimary, Colors.white, context);
                      }
                    } catch (e) {
                      Navigator.pop(context); // Close loading
                       Navigator.pop(context);
                       showSnackbar("An Error Occurred : ${e.toString()}", Colors.red, Colors.white, context);
                      
                    }
                  }
                },
                child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    },
  );
}



Future<void> showEditScheduleModal(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? selectedFrequency;

  // Fetch current user's existing schedule
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
  final data = userDoc.data();
  final existingSchedule = data?['schedule'];

  if (existingSchedule != null) {
    selectedDay = existingSchedule['day'];
    final existingTime = existingSchedule['time'];
    if (existingTime != null && existingTime is String) {
      final timeParts = existingTime.split(':');
      selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1].split(' ')[0]),
      );
    }
    selectedFrequency = existingSchedule['frequency'];
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text('Edit schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Day Picker
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: selectedDay != null ? DateTime.parse(selectedDay!).toLocal().toString().split(' ')[0] : '',
                ),
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    initialDate: selectedDay != null ? DateTime.parse(selectedDay!) : DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (result != null) {
                    selectedDay = result.toIso8601String();
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Select your preferred pickup day',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (_) => selectedDay == null ? 'Please select a day' : null,
              ),
              const SizedBox(height: 16),

              // Time Picker
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: selectedTime != null ? selectedTime!.format(context) : '',
                ),
                onTap: () async {
                  final result = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (result != null) {
                    selectedTime = result;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Select your preferred pickup time',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (_) => selectedTime == null ? 'Please select a time' : null,
              ),
              const SizedBox(height: 16),

              // Frequency Dropdown
              DropdownButtonFormField<String>(
                value: selectedFrequency,
                decoration: InputDecoration(
                  labelText: 'Select your preferred',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: ['Once a week', 'Twice a week', 'Daily']
                    .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                    .toList(),
                onChanged: (val) => selectedFrequency = val,
                validator: (_) => selectedFrequency == null ? 'Please select frequency' : null,
              ),
              const SizedBox(height: 24),

              // Done Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedSchedule = {
                      'day': selectedDay,
                      'time': selectedTime?.format(context),
                      'frequency': selectedFrequency,
                    };

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userEmail)
                        .set({'schedule': updatedSchedule}, SetOptions(merge: true));

                    Navigator.pop(context);
                  }
                },
                child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    },
  );
}
