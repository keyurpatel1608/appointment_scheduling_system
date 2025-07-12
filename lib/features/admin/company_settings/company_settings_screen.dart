import 'package:flutter/material.dart';

class CompanySettingsScreen extends StatefulWidget {
  const CompanySettingsScreen({super.key});

  @override
  State<CompanySettingsScreen> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _generalFormKey = GlobalKey<FormState>();
  final _workingHoursFormKey = GlobalKey<FormState>();
  final _appointmentFormKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Company data
  late CompanySettings _companySettings;
  late CompanySettings _editedSettings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Simulate loading company settings
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _companySettings = _getMockCompanySettings();
        _editedSettings = _companySettings.copy();
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  CompanySettings _getMockCompanySettings() {
    return CompanySettings(
      id: 'COMP001',
      name: 'Acme Corporation',
      logo: 'https://via.placeholder.com/150',
      address: '123 Business Ave, Suite 500, New York, NY 10001',
      phone: '+1 (555) 123-4567',
      email: 'info@acmecorp.example.com',
      website: 'www.acmecorp.example.com',
      description: 'Leading provider of innovative business solutions.',
      workingHours: WorkingHours(
        mondayToFriday: const TimeRange(
          start: TimeOfDay(hour: 9, minute: 0),
          end: TimeOfDay(hour: 17, minute: 0),
        ),
        saturday: const TimeRange(
          start: TimeOfDay(hour: 10, minute: 0),
          end: TimeOfDay(hour: 14, minute: 0),
        ),
        sunday: null,
        holidays: [
          DateTime(2023, 1, 1),  // New Year's Day
          DateTime(2023, 12, 25), // Christmas
        ],
      ),
      appointmentSettings: AppointmentSettings(
        defaultDuration: 30,
        minAdvanceTime: 24,
        maxAdvanceBooking: 30,
        allowRescheduling: true,
        rescheduleTimeLimit: 12,
        allowCancellation: true,
        cancellationTimeLimit: 24,
        autoConfirm: false,
        bufferBetweenAppointments: 15,
        appointmentTypes: [
          AppointmentType(id: '1', name: 'Meeting', color: Colors.blue, duration: 30),
          AppointmentType(id: '2', name: 'Interview', color: Colors.purple, duration: 60),
          AppointmentType(id: '3', name: 'Consultation', color: Colors.green, duration: 45),
          AppointmentType(id: '4', name: 'Workshop', color: Colors.orange, duration: 120),
        ],
      ),
      notificationSettings: NotificationSettings(
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: false,
        reminderTimes: [10, 30, 60], // minutes before appointment
      ),
      integrations: [
        Integration(name: 'Google Calendar', isEnabled: true, apiKey: 'abc123'),
        Integration(name: 'Microsoft Teams', isEnabled: false, apiKey: ''),
        Integration(name: 'Slack', isEnabled: true, apiKey: 'xyz789'),
      ],
    );
  }

  void _saveSettings() {
    bool isValid = true;
    
    // Validate the active tab form
    switch (_tabController.index) {
      case 0: // General
        isValid = _generalFormKey.currentState?.validate() ?? false;
        break;
      case 1: // Working Hours
        isValid = _workingHoursFormKey.currentState?.validate() ?? false;
        break;
      case 2: // Appointment Settings
        isValid = _appointmentFormKey.currentState?.validate() ?? false;
        break;
      case 3: // Integrations
        // No validation needed for integrations tab
        break;
    }
    
    if (!isValid) return;
    
    // Save the form data
    _generalFormKey.currentState?.save();
    _workingHoursFormKey.currentState?.save();
    _appointmentFormKey.currentState?.save();
    
    // In a real app, this would send the updated settings to a server
    setState(() {
      _isSaving = true;
    });
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _companySettings = _editedSettings.copy();
        _isSaving = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company settings updated successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Settings'),
        bottom: _isLoading
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'General'),
                  Tab(text: 'Working Hours'),
                  Tab(text: 'Appointment Settings'),
                  Tab(text: 'Integrations'),
                ],
              ),
        actions: [
          if (!_isLoading && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save Settings',
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isSaving
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Saving settings...'),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGeneralSettingsTab(),
                    _buildWorkingHoursTab(),
                    _buildAppointmentSettingsTab(),
                    _buildIntegrationsTab(),
                  ],
                ),
    );
  }

  Widget _buildGeneralSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _generalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(_editedSettings.logo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Company Logo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: _editedSettings.name,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter company name';
                }
                return null;
              },
              onSaved: (value) {
                _editedSettings = _editedSettings.copyWith(name: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedSettings.email,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email address';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) {
                _editedSettings = _editedSettings.copyWith(email: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedSettings.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
              onSaved: (value) {
                _editedSettings = _editedSettings.copyWith(phone: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedSettings.website,
              decoration: const InputDecoration(
                labelText: 'Website',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                _editedSettings = _editedSettings.copyWith(website: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedSettings.address,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onSaved: (value) {
                _editedSettings = _editedSettings.copyWith(address: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedSettings.description,
              decoration: const InputDecoration(
                labelText: 'Company Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onSaved: (value) {
                _editedSettings = _editedSettings.copyWith(description: value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _workingHoursFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regular Working Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monday to Friday',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerField(
                            label: 'Start Time',
                            timeOfDay: _editedSettings.workingHours.mondayToFriday.start,
                            onChanged: (time) {
                              setState(() {
                                final updatedRange = TimeRange(
                                  start: time,
                                  end: _editedSettings.workingHours.mondayToFriday.end,
                                );
                                final updatedHours = _editedSettings.workingHours.copyWith(
                                  mondayToFriday: updatedRange,
                                );
                                _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimePickerField(
                            label: 'End Time',
                            timeOfDay: _editedSettings.workingHours.mondayToFriday.end,
                            onChanged: (time) {
                              setState(() {
                                final updatedRange = TimeRange(
                                  start: _editedSettings.workingHours.mondayToFriday.start,
                                  end: time,
                                );
                                final updatedHours = _editedSettings.workingHours.copyWith(
                                  mondayToFriday: updatedRange,
                                );
                                _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saturday',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: _editedSettings.workingHours.saturday != null,
                          onChanged: (value) {
                            setState(() {
                              final updatedHours = _editedSettings.workingHours.copyWith(
                                saturday: value
                                    ? const TimeRange(
                                        start: TimeOfDay(hour: 10, minute: 0),
                                        end: TimeOfDay(hour: 14, minute: 0),
                                      )
                                    : null,
                              );
                              _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                            });
                          },
                        ),
                      ],
                    ),
                    if (_editedSettings.workingHours.saturday != null) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePickerField(
                              label: 'Start Time',
                              timeOfDay: _editedSettings.workingHours.saturday!.start,
                              onChanged: (time) {
                                setState(() {
                                  final updatedRange = TimeRange(
                                    start: time,
                                    end: _editedSettings.workingHours.saturday!.end,
                                  );
                                  final updatedHours = _editedSettings.workingHours.copyWith(
                                    saturday: updatedRange,
                                  );
                                  _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePickerField(
                              label: 'End Time',
                              timeOfDay: _editedSettings.workingHours.saturday!.end,
                              onChanged: (time) {
                                setState(() {
                                  final updatedRange = TimeRange(
                                    start: _editedSettings.workingHours.saturday!.start,
                                    end: time,
                                  );
                                  final updatedHours = _editedSettings.workingHours.copyWith(
                                    saturday: updatedRange,
                                  );
                                  _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sunday',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: _editedSettings.workingHours.sunday != null,
                          onChanged: (value) {
                            setState(() {
                              final updatedHours = _editedSettings.workingHours.copyWith(
                                sunday: value
                                    ? const TimeRange(
                                        start: TimeOfDay(hour: 10, minute: 0),
                                        end: TimeOfDay(hour: 14, minute: 0),
                                      )
                                    : null,
                              );
                              _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                            });
                          },
                        ),
                      ],
                    ),
                    if (_editedSettings.workingHours.sunday != null) ...[  
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePickerField(
                              label: 'Start Time',
                              timeOfDay: _editedSettings.workingHours.sunday!.start,
                              onChanged: (time) {
                                setState(() {
                                  final updatedRange = TimeRange(
                                    start: time,
                                    end: _editedSettings.workingHours.sunday!.end,
                                  );
                                  final updatedHours = _editedSettings.workingHours.copyWith(
                                    sunday: updatedRange,
                                  );
                                  _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePickerField(
                              label: 'End Time',
                              timeOfDay: _editedSettings.workingHours.sunday!.end,
                              onChanged: (time) {
                                setState(() {
                                  final updatedRange = TimeRange(
                                    start: _editedSettings.workingHours.sunday!.start,
                                    end: time,
                                  );
                                  final updatedHours = _editedSettings.workingHours.copyWith(
                                    sunday: updatedRange,
                                  );
                                  _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Holidays',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Company Holidays'),
                        ElevatedButton.icon(
                          onPressed: () {
                            _addHoliday(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Holiday'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_editedSettings.workingHours.holidays.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No holidays added yet'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _editedSettings.workingHours.holidays.length,
                        itemBuilder: (context, index) {
                          final holiday = _editedSettings.workingHours.holidays[index];
                          return ListTile(
                            title: Text(
                              '${holiday.month}/${holiday.day}/${holiday.year}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  final updatedHolidays = List<DateTime>.from(_editedSettings.workingHours.holidays);
                                  updatedHolidays.removeAt(index);
                                  final updatedHours = _editedSettings.workingHours.copyWith(
                                    holidays: updatedHolidays,
                                  );
                                  _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
                                });
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addHoliday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    
    if (picked != null) {
      setState(() {
        final updatedHolidays = List<DateTime>.from(_editedSettings.workingHours.holidays);
        updatedHolidays.add(picked);
        final updatedHours = _editedSettings.workingHours.copyWith(
          holidays: updatedHolidays,
        );
        _editedSettings = _editedSettings.copyWith(workingHours: updatedHours);
      });
    }
  }

  Widget _buildAppointmentSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _appointmentFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildNumberField(
                      label: 'Default Appointment Duration (minutes)',
                      value: _editedSettings.appointmentSettings.defaultDuration,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            defaultDuration: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      label: 'Minimum Advance Booking Time (hours)',
                      value: _editedSettings.appointmentSettings.minAdvanceTime,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            minAdvanceTime: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      label: 'Maximum Advance Booking (days)',
                      value: _editedSettings.appointmentSettings.maxAdvanceBooking,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            maxAdvanceBooking: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildNumberField(
                      label: 'Buffer Between Appointments (minutes)',
                      value: _editedSettings.appointmentSettings.bufferBetweenAppointments,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            bufferBetweenAppointments: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Rescheduling & Cancellation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Allow Rescheduling'),
                      value: _editedSettings.appointmentSettings.allowRescheduling,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            allowRescheduling: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                    if (_editedSettings.appointmentSettings.allowRescheduling)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                        child: _buildNumberField(
                          label: 'Reschedule Time Limit (hours before appointment)',
                          value: _editedSettings.appointmentSettings.rescheduleTimeLimit,
                          onChanged: (value) {
                            setState(() {
                              final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                                rescheduleTimeLimit: value,
                              );
                              _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                            });
                          },
                        ),
                      ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Allow Cancellation'),
                      value: _editedSettings.appointmentSettings.allowCancellation,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            allowCancellation: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                    if (_editedSettings.appointmentSettings.allowCancellation)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                        child: _buildNumberField(
                          label: 'Cancellation Time Limit (hours before appointment)',
                          value: _editedSettings.appointmentSettings.cancellationTimeLimit,
                          onChanged: (value) {
                            setState(() {
                              final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                                cancellationTimeLimit: value,
                              );
                              _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                            });
                          },
                        ),
                      ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Auto-confirm Appointments'),
                      subtitle: const Text('Automatically confirm appointments without admin approval'),
                      value: _editedSettings.appointmentSettings.autoConfirm,
                      onChanged: (value) {
                        setState(() {
                          final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                            autoConfirm: value,
                          );
                          _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Appointment Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Manage Appointment Types'),
                        ElevatedButton.icon(
                          onPressed: () {
                            _addAppointmentType(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Type'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _editedSettings.appointmentSettings.appointmentTypes.length,
                      itemBuilder: (context, index) {
                        final type = _editedSettings.appointmentSettings.appointmentTypes[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: type.color,
                            radius: 12,
                          ),
                          title: Text(type.name),
                          subtitle: Text('${type.duration} minutes'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editAppointmentType(context, index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    final updatedTypes = List<AppointmentType>.from(
                                      _editedSettings.appointmentSettings.appointmentTypes,
                                    );
                                    updatedTypes.removeAt(index);
                                    final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                                      appointmentTypes: updatedTypes,
                                    );
                                    _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAppointmentType(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController durationController = TextEditingController(text: '30');
    Color selectedColor = Colors.blue;
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Appointment Type'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Type Name',
                      hintText: 'e.g., Meeting, Interview',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (minutes)',
                      hintText: 'e.g., 30, 60',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Text('Color'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildColorOption(Colors.blue, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.red, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.green, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.orange, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.purple, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.teal, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && durationController.text.isNotEmpty) {
                    final newType = AppointmentType(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      color: selectedColor,
                      duration: int.tryParse(durationController.text) ?? 30,
                    );
                    
                    this.setState(() {
                      final updatedTypes = List<AppointmentType>.from(
                        _editedSettings.appointmentSettings.appointmentTypes,
                      );
                      updatedTypes.add(newType);
                      final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                        appointmentTypes: updatedTypes,
                      );
                      _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                    });
                    
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editAppointmentType(BuildContext context, int index) async {
    final type = _editedSettings.appointmentSettings.appointmentTypes[index];
    final TextEditingController nameController = TextEditingController(text: type.name);
    final TextEditingController durationController = TextEditingController(text: type.duration.toString());
    Color selectedColor = type.color;
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Appointment Type'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Type Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (minutes)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Text('Color'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildColorOption(Colors.blue, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.red, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.green, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.orange, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.purple, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                      _buildColorOption(Colors.teal, selectedColor, (color) {
                        setState(() => selectedColor = color);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && durationController.text.isNotEmpty) {
                    final updatedType = AppointmentType(
                      id: type.id,
                      name: nameController.text,
                      color: selectedColor,
                      duration: int.tryParse(durationController.text) ?? 30,
                    );
                    
                    this.setState(() {
                      final updatedTypes = List<AppointmentType>.from(
                        _editedSettings.appointmentSettings.appointmentTypes,
                      );
                      updatedTypes[index] = updatedType;
                      final updatedSettings = _editedSettings.appointmentSettings.copyWith(
                        appointmentTypes: updatedTypes,
                      );
                      _editedSettings = _editedSettings.copyWith(appointmentSettings: updatedSettings);
                    });
                    
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorOption(Color color, Color selectedColor, Function(Color) onSelect) {
    final isSelected = color.value == selectedColor.value;
    
    return GestureDetector(
      onTap: () => onSelect(color),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildIntegrationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'External Integrations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect your appointment system with other services',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _editedSettings.integrations.length,
            itemBuilder: (context, index) {
              final integration = _editedSettings.integrations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            integration.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: integration.isEnabled,
                            onChanged: (value) {
                              setState(() {
                                final updatedIntegration = integration.copyWith(isEnabled: value);
                                final updatedIntegrations = List<Integration>.from(_editedSettings.integrations);
                                updatedIntegrations[index] = updatedIntegration;
                                _editedSettings = _editedSettings.copyWith(integrations: updatedIntegrations);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (integration.isEnabled) ...[  
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'API Key',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          initialValue: integration.apiKey,
                          onChanged: (value) {
                            setState(() {
                              final updatedIntegration = integration.copyWith(apiKey: value);
                              final updatedIntegrations = List<Integration>.from(_editedSettings.integrations);
                              updatedIntegrations[index] = updatedIntegration;
                              _editedSettings = _editedSettings.copyWith(integrations: updatedIntegrations);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                // In a real app, this would test the connection
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Testing connection to ${integration.name}...')),
                                );
                              },
                              child: const Text('Test Connection'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // In a real app, this would configure advanced settings
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Configure ${integration.name} settings')),
                                );
                              },
                              child: const Text('Configure'),
                            ),
                          ],
                        ),
                      ] else
                        const Text(
                          'Enable this integration to configure settings',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // In a real app, this would open a dialog to add a new integration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new integration (not implemented in demo)')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Integration'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required TimeOfDay timeOfDay,
    required Function(TimeOfDay) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: timeOfDay,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(_formatTimeOfDay(timeOfDay)),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    final controller = TextEditingController(text: value.toString());
    
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onChanged: (value) {
        final intValue = int.tryParse(value);
        if (intValue != null) {
          onChanged(intValue);
        }
      },
    );
  }
}

class CompanySettings {
  final String id;
  final String name;
  final String logo;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String description;
  final WorkingHours workingHours;
  final AppointmentSettings appointmentSettings;
  final NotificationSettings notificationSettings;
  final List<Integration> integrations;

  CompanySettings({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.description,
    required this.workingHours,
    required this.appointmentSettings,
    required this.notificationSettings,
    required this.integrations,
  });

  CompanySettings copyWith({
    String? id,
    String? name,
    String? logo,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? description,
    WorkingHours? workingHours,
    AppointmentSettings? appointmentSettings,
    NotificationSettings? notificationSettings,
    List<Integration>? integrations,
  }) {
    return CompanySettings(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      description: description ?? this.description,
      workingHours: workingHours ?? this.workingHours,
      appointmentSettings: appointmentSettings ?? this.appointmentSettings,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      integrations: integrations ?? this.integrations,
    );
  }

  CompanySettings copy() {
    return copyWith(
      workingHours: workingHours.copy(),
      appointmentSettings: appointmentSettings.copy(),
      notificationSettings: notificationSettings.copy(),
      integrations: integrations.map((integration) => integration.copy()).toList(),
    );
  }
}

class WorkingHours {
  final TimeRange mondayToFriday;
  final TimeRange? saturday;
  final TimeRange? sunday;
  final List<DateTime> holidays;

  WorkingHours({
    required this.mondayToFriday,
    this.saturday,
    this.sunday,
    required this.holidays,
  });

  WorkingHours copyWith({
    TimeRange? mondayToFriday,
    TimeRange? saturday,
    TimeRange? sunday,
    List<DateTime>? holidays,
  }) {
    return WorkingHours(
      mondayToFriday: mondayToFriday ?? this.mondayToFriday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      holidays: holidays ?? this.holidays,
    );
  }

  WorkingHours copy() {
    return copyWith(
      holidays: List<DateTime>.from(holidays),
    );
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeRange({
    required this.start,
    required this.end,
  });
}

class AppointmentSettings {
  final int defaultDuration;
  final int minAdvanceTime;
  final int maxAdvanceBooking;
  final bool allowRescheduling;
  final int rescheduleTimeLimit;
  final bool allowCancellation;
  final int cancellationTimeLimit;
  final bool autoConfirm;
  final int bufferBetweenAppointments;
  final List<AppointmentType> appointmentTypes;

  AppointmentSettings({
    required this.defaultDuration,
    required this.minAdvanceTime,
    required this.maxAdvanceBooking,
    required this.allowRescheduling,
    required this.rescheduleTimeLimit,
    required this.allowCancellation,
    required this.cancellationTimeLimit,
    required this.autoConfirm,
    required this.bufferBetweenAppointments,
    required this.appointmentTypes,
  });

  AppointmentSettings copyWith({
    int? defaultDuration,
    int? minAdvanceTime,
    int? maxAdvanceBooking,
    bool? allowRescheduling,
    int? rescheduleTimeLimit,
    bool? allowCancellation,
    int? cancellationTimeLimit,
    bool? autoConfirm,
    int? bufferBetweenAppointments,
    List<AppointmentType>? appointmentTypes,
  }) {
    return AppointmentSettings(
      defaultDuration: defaultDuration ?? this.defaultDuration,
      minAdvanceTime: minAdvanceTime ?? this.minAdvanceTime,
      maxAdvanceBooking: maxAdvanceBooking ?? this.maxAdvanceBooking,
      allowRescheduling: allowRescheduling ?? this.allowRescheduling,
      rescheduleTimeLimit: rescheduleTimeLimit ?? this.rescheduleTimeLimit,
      allowCancellation: allowCancellation ?? this.allowCancellation,
      cancellationTimeLimit: cancellationTimeLimit ?? this.cancellationTimeLimit,
      autoConfirm: autoConfirm ?? this.autoConfirm,
      bufferBetweenAppointments: bufferBetweenAppointments ?? this.bufferBetweenAppointments,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
    );
  }

  AppointmentSettings copy() {
    return copyWith(
      appointmentTypes: appointmentTypes.map((type) => type.copy()).toList(),
    );
  }
}

class AppointmentType {
  final String id;
  final String name;
  final Color color;
  final int duration;

  AppointmentType({
    required this.id,
    required this.name,
    required this.color,
    required this.duration,
  });

  AppointmentType copyWith({
    String? id,
    String? name,
    Color? color,
    int? duration,
  }) {
    return AppointmentType(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      duration: duration ?? this.duration,
    );
  }

  AppointmentType copy() {
    return copyWith();
  }
}

class NotificationSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final List<int> reminderTimes;

  NotificationSettings({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.reminderTimes,
  });

  NotificationSettings copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    List<int>? reminderTimes,
  }) {
    return NotificationSettings(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      reminderTimes: reminderTimes ?? this.reminderTimes,
    );
  }

  NotificationSettings copy() {
    return copyWith(
      reminderTimes: List<int>.from(reminderTimes),
    );
  }
}

class Integration {
  final String name;
  final bool isEnabled;
  final String apiKey;

  Integration({
    required this.name,
    required this.isEnabled,
    required this.apiKey,
  });

  Integration copyWith({
    String? name,
    bool? isEnabled,
    String? apiKey,
  }) {
    return Integration(
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
      apiKey: apiKey ?? this.apiKey,
    );
  }

  Integration copy() {
    return copyWith();
  }
}