import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic>? cloneFrom;

  const CreateAppointmentScreen({super.key, this.cloneFrom});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  
  String _appointmentType = 'Meeting';
  final List<String> _appointmentTypes = [
    'Meeting',
    'Interview',
    'Conference',
    'Workshop',
    'Training',
    'Other'
  ];
  
  final List<Map<String, dynamic>> _participants = [];
  final TextEditingController _participantController = TextEditingController();
  
  bool _isVirtual = false;
  bool _sendReminders = true;
  bool _isRecurring = false;
  String _recurringPattern = 'Weekly';
  final List<String> _recurringPatterns = [
    'Daily',
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'Custom'
  ];

  @override
  void initState() {
    super.initState();
    _updateDateTimeControllers();
    
    // If cloning from an existing appointment, pre-fill the form
    if (widget.cloneFrom != null) {
      _prefillFromExisting();
    }
  }

  void _prefillFromExisting() {
    // This would be implemented to pre-fill form from an existing appointment
    // For now, we'll just simulate with some sample data
    _titleController.text = 'Copy of Project Meeting';
    _descriptionController.text = 'Follow-up discussion on project progress';
    _locationController.text = 'Conference Room B';
    _appointmentType = 'Meeting';
    _isVirtual = true;
    
    // Add some sample participants
    _participants.addAll([
      {'name': 'John Smith', 'email': 'john.smith@example.com', 'role': 'Project Manager'},
      {'name': 'Sarah Johnson', 'email': 'sarah.j@example.com', 'role': 'Developer'},
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _participantController.dispose();
    super.dispose();
  }

  void _updateDateTimeControllers() {
    _dateController.text = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);
    _startTimeController.text = _startTime.format(context);
    _endTimeController.text = _endTime.format(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateTimeControllers();
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        // Automatically set end time to 1 hour after start time
        _endTime = TimeOfDay(
          hour: (picked.hour + 1) % 24,
          minute: picked.minute,
        );
        _updateDateTimeControllers();
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
        _updateDateTimeControllers();
      });
    }
  }

  void _addParticipant() {
    if (_participantController.text.isEmpty) return;
    
    // In a real app, you would validate the email and possibly search a database
    // For now, we'll just add the participant with a dummy email
    final name = _participantController.text;
    setState(() {
      _participants.add({
        'name': name,
        'email': '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
        'role': 'Attendee',
      });
      _participantController.clear();
    });
  }

  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would save the appointment to a database
      // For now, we'll just show a success message and navigate back
      
      // Simulate API call
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Simulate delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // Close loading dialog
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment created successfully')),
        );
        
        // Navigate back to appointments list
        context.go('/appointments');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cloneFrom != null ? 'Clone Appointment' : 'Create Appointment'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicDetailsSection(),
              const SizedBox(height: 24),
              _buildDateTimeSection(),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildParticipantsSection(),
              const SizedBox(height: 24),
              _buildRecurrenceSection(),
              const SizedBox(height: 24),
              _buildReminderSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicDetailsSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _appointmentType,
              decoration: const InputDecoration(
                labelText: 'Appointment Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _appointmentTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _appointmentType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date & Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startTimeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () => _selectStartTime(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _endTimeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () => _selectEndTime(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Virtual Meeting'),
              subtitle: const Text('Enable for online meetings'),
              value: _isVirtual,
              onChanged: (bool value) {
                setState(() {
                  _isVirtual = value;
                  if (value) {
                    _locationController.text = 'Virtual Meeting';
                  } else {
                    _locationController.text = '';
                  }
                });
              },
              secondary: Icon(
                _isVirtual ? Icons.videocam : Icons.location_on,
                color: _isVirtual ? Colors.blue : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              enabled: !_isVirtual,
              decoration: InputDecoration(
                labelText: _isVirtual ? 'Meeting Link' : 'Location',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(_isVirtual ? Icons.link : Icons.location_on),
                hintText: _isVirtual ? 'Enter meeting link' : 'Enter location',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return _isVirtual ? 'Please enter a meeting link' : 'Please enter a location';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Participants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_participants.isNotEmpty)
                  Chip(
                    label: Text('${_participants.length} People'),
                    backgroundColor: Colors.blue,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _participantController,
                    decoration: const InputDecoration(
                      labelText: 'Add Participant',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_add),
                      hintText: 'Enter name or email',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.blue,
                  onPressed: _addParticipant,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_participants.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No participants added yet',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _participants.length,
                itemBuilder: (context, index) {
                  final participant = _participants[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        participant['name'].substring(0, 1),
                        style: TextStyle(color: Colors.blue.shade800),
                      ),
                    ),
                    title: Text(participant['name']),
                    subtitle: Text(participant['email']),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () => _removeParticipant(index),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurrenceSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recurrence',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Recurring Appointment'),
              subtitle: const Text('Set up a repeating schedule'),
              value: _isRecurring,
              onChanged: (bool value) {
                setState(() {
                  _isRecurring = value;
                });
              },
              secondary: const Icon(Icons.repeat),
            ),
            if (_isRecurring) ...[              
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _recurringPattern,
                decoration: const InputDecoration(
                  labelText: 'Repeat Pattern',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_view_month),
                ),
                items: _recurringPatterns.map((String pattern) {
                  return DropdownMenuItem<String>(
                    value: pattern,
                    child: Text(pattern),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _recurringPattern = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // Additional recurrence options would go here
              const ListTile(
                title: Text('End Recurrence'),
                subtitle: Text('After 10 occurrences'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Send Reminders'),
              subtitle: const Text('Notify participants before the appointment'),
              value: _sendReminders,
              onChanged: (bool value) {
                setState(() {
                  _sendReminders = value;
                });
              },
              secondary: const Icon(Icons.notifications),
            ),
            if (_sendReminders) ...[              
              const SizedBox(height: 16),
              // Reminder options would go here
              const ListTile(
                title: Text('Reminder Time'),
                subtitle: Text('15 minutes before'),
                trailing: Icon(Icons.chevron_right),
              ),
              const Divider(),
              const ListTile(
                title: Text('Notification Method'),
                subtitle: Text('Email and Push Notification'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Create Appointment',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}