import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isLoading = true;
  late UserProfile _userProfile;
  late UserProfile _editedProfile;

  @override
  void initState() {
    super.initState();
    // Simulate loading profile data
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _userProfile = _getMockUserProfile();
        _editedProfile = _userProfile.copy();
        _isLoading = false;
      });
    });
  }

  UserProfile _getMockUserProfile() {
    return UserProfile(
      id: 'USR12345',
      name: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      phone: '+1 (555) 123-4567',
      role: 'Product Manager',
      department: 'Product Development',
      location: 'New York Office',
      bio: 'Experienced product manager with a passion for creating user-friendly solutions.',
      profileImage: 'https://i.pravatar.cc/300?img=8',
      joinDate: DateTime(2020, 3, 15),
      workHours: const WorkHours(
        monday: TimeRange(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 17, minute: 0)),
        tuesday: TimeRange(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 17, minute: 0)),
        wednesday: TimeRange(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 17, minute: 0)),
        thursday: TimeRange(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 17, minute: 0)),
        friday: TimeRange(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 16, minute: 0)),
        saturday: null,
        sunday: null,
      ),
      preferences: UserPreferences(
        notificationEnabled: true,
        emailNotifications: true,
        pushNotifications: true,
        reminderTime: 30, // minutes before appointment
        theme: 'System',
        language: 'English',
        timeFormat: '12h',
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Discard changes
        _editedProfile = _userProfile.copy();
      }
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // In a real app, this would send the updated profile to a server
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _userProfile = _editedProfile.copy();
          _isEditing = false;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      });
    }
  }

  Future<void> _selectWorkHours(BuildContext context, String day) async {
    final TimeRange? currentRange = _getWorkHoursForDay(day);
    
    // Select start time
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: currentRange?.start ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Select start time',
    );
    
    if (startTime == null) return;
    
    // Select end time
    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: currentRange?.end ?? const TimeOfDay(hour: 17, minute: 0),
      helpText: 'Select end time',
    );
    
    if (endTime == null) return;
    
    setState(() {
      _setWorkHoursForDay(day, TimeRange(start: startTime, end: endTime));
    });
  }

  TimeRange? _getWorkHoursForDay(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return _editedProfile.workHours.monday;
      case 'tuesday':
        return _editedProfile.workHours.tuesday;
      case 'wednesday':
        return _editedProfile.workHours.wednesday;
      case 'thursday':
        return _editedProfile.workHours.thursday;
      case 'friday':
        return _editedProfile.workHours.friday;
      case 'saturday':
        return _editedProfile.workHours.saturday;
      case 'sunday':
        return _editedProfile.workHours.sunday;
      default:
        return null;
    }
  }

  void _setWorkHoursForDay(String day, TimeRange? timeRange) {
    final updatedWorkHours = WorkHours(
      monday: day.toLowerCase() == 'monday' ? timeRange : _editedProfile.workHours.monday,
      tuesday: day.toLowerCase() == 'tuesday' ? timeRange : _editedProfile.workHours.tuesday,
      wednesday: day.toLowerCase() == 'wednesday' ? timeRange : _editedProfile.workHours.wednesday,
      thursday: day.toLowerCase() == 'thursday' ? timeRange : _editedProfile.workHours.thursday,
      friday: day.toLowerCase() == 'friday' ? timeRange : _editedProfile.workHours.friday,
      saturday: day.toLowerCase() == 'saturday' ? timeRange : _editedProfile.workHours.saturday,
      sunday: day.toLowerCase() == 'sunday' ? timeRange : _editedProfile.workHours.sunday,
    );
    
    setState(() {
      _editedProfile = _editedProfile.copyWith(workHours: updatedWorkHours);
    });
  }

  void _toggleDayOff(String day) {
    final currentRange = _getWorkHoursForDay(day);
    setState(() {
      if (currentRange == null) {
        // If it's currently a day off, set default hours
        _setWorkHoursForDay(
          day,
          const TimeRange(
            start: TimeOfDay(hour: 9, minute: 0),
            end: TimeOfDay(hour: 17, minute: 0),
          ),
        );
      } else {
        // If it currently has hours, set to day off
        _setWorkHoursForDay(day, null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
              tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildPersonalInfoSection(),
                    const SizedBox(height: 24),
                    _buildWorkHoursSection(),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(),
                    const SizedBox(height: 32),
                    if (_isEditing)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_userProfile.profileImage),
              ),
              if (_isEditing)
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
          _isEditing
              ? TextFormField(
                  initialValue: _editedProfile.name,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProfile = _editedProfile.copyWith(name: value);
                  },
                )
              : Text(
                  _userProfile.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: 8),
          Text(
            _userProfile.role,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(
            _userProfile.department,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Email',
              value: _userProfile.email,
              icon: Icons.email,
              isEditable: true,
              onSaved: (value) {
                _editedProfile = _editedProfile.copyWith(email: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const Divider(),
            _buildInfoField(
              label: 'Phone',
              value: _userProfile.phone,
              icon: Icons.phone,
              isEditable: true,
              onSaved: (value) {
                _editedProfile = _editedProfile.copyWith(phone: value);
              },
            ),
            const Divider(),
            _buildInfoField(
              label: 'Location',
              value: _userProfile.location,
              icon: Icons.location_on,
              isEditable: true,
              onSaved: (value) {
                _editedProfile = _editedProfile.copyWith(location: value);
              },
            ),
            const Divider(),
            _buildInfoField(
              label: 'Bio',
              value: _userProfile.bio,
              icon: Icons.person_outline,
              isEditable: true,
              isMultiline: true,
              onSaved: (value) {
                _editedProfile = _editedProfile.copyWith(bio: value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkHoursSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Work Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Set your regular working hours to help others schedule appointments with you.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildWorkHoursDay('Monday', _editedProfile.workHours.monday),
            _buildWorkHoursDay('Tuesday', _editedProfile.workHours.tuesday),
            _buildWorkHoursDay('Wednesday', _editedProfile.workHours.wednesday),
            _buildWorkHoursDay('Thursday', _editedProfile.workHours.thursday),
            _buildWorkHoursDay('Friday', _editedProfile.workHours.friday),
            _buildWorkHoursDay('Saturday', _editedProfile.workHours.saturday),
            _buildWorkHoursDay('Sunday', _editedProfile.workHours.sunday),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkHoursDay(String day, TimeRange? timeRange) {
    final bool isDayOff = timeRange == null;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: isDayOff
                ? const Text('Day Off', style: TextStyle(color: Colors.grey))
                : Text(
                    '${_formatTimeOfDay(timeRange.start)} - ${_formatTimeOfDay(timeRange.end)}',
                  ),
          ),
          if (_isEditing) ...[  
            IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () => _selectWorkHours(context, day),
              tooltip: 'Set hours',
            ),
            IconButton(
              icon: Icon(isDayOff ? Icons.add_circle_outline : Icons.remove_circle_outline),
              onPressed: () => _toggleDayOff(day),
              tooltip: isDayOff ? 'Add work hours' : 'Set as day off',
              color: isDayOff ? Colors.green : Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSwitchPreference(
              title: 'Enable Notifications',
              value: _editedProfile.preferences.notificationEnabled,
              onChanged: (value) {
                setState(() {
                  final updatedPreferences = _editedProfile.preferences.copyWith(
                    notificationEnabled: value,
                  );
                  _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                });
              },
            ),
            if (_editedProfile.preferences.notificationEnabled) ...[  
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  children: [
                    _buildSwitchPreference(
                      title: 'Email Notifications',
                      value: _editedProfile.preferences.emailNotifications,
                      onChanged: (value) {
                        setState(() {
                          final updatedPreferences = _editedProfile.preferences.copyWith(
                            emailNotifications: value,
                          );
                          _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                        });
                      },
                    ),
                    _buildSwitchPreference(
                      title: 'Push Notifications',
                      value: _editedProfile.preferences.pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          final updatedPreferences = _editedProfile.preferences.copyWith(
                            pushNotifications: value,
                          );
                          _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
            const Divider(),
            _buildDropdownPreference(
              title: 'Reminder Time',
              value: _editedProfile.preferences.reminderTime.toString(),
              options: const ['10', '15', '30', '60'],
              labelBuilder: (value) => '$value minutes before',
              onChanged: (value) {
                setState(() {
                  final updatedPreferences = _editedProfile.preferences.copyWith(
                    reminderTime: int.parse(value),
                  );
                  _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                });
              },
            ),
            const Divider(),
            _buildDropdownPreference(
              title: 'Theme',
              value: _editedProfile.preferences.theme,
              options: const ['System', 'Light', 'Dark'],
              onChanged: (value) {
                setState(() {
                  final updatedPreferences = _editedProfile.preferences.copyWith(
                    theme: value,
                  );
                  _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                });
              },
            ),
            const Divider(),
            _buildDropdownPreference(
              title: 'Language',
              value: _editedProfile.preferences.language,
              options: const ['English', 'Spanish', 'French', 'German', 'Chinese'],
              onChanged: (value) {
                setState(() {
                  final updatedPreferences = _editedProfile.preferences.copyWith(
                    language: value,
                  );
                  _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                });
              },
            ),
            const Divider(),
            _buildDropdownPreference(
              title: 'Time Format',
              value: _editedProfile.preferences.timeFormat,
              options: const ['12h', '24h'],
              onChanged: (value) {
                setState(() {
                  final updatedPreferences = _editedProfile.preferences.copyWith(
                    timeFormat: value,
                  );
                  _editedProfile = _editedProfile.copyWith(preferences: updatedPreferences);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
    bool isEditable = false,
    bool isMultiline = false,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: _isEditing && isEditable
                ? TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(labelText: label),
                    maxLines: isMultiline ? 3 : 1,
                    validator: validator,
                    onSaved: onSaved,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(value),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchPreference({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Switch(
            value: value,
            onChanged: _isEditing ? onChanged : null,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownPreference({
    required String title,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
    String Function(String)? labelBuilder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          _isEditing
              ? DropdownButton<String>(
                  value: value,
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(labelBuilder != null ? labelBuilder(option) : option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                )
              : Text(
                  labelBuilder != null ? labelBuilder(value) : value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
        ],
      ),
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String department;
  final String location;
  final String bio;
  final String profileImage;
  final DateTime joinDate;
  final WorkHours workHours;
  final UserPreferences preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.location,
    required this.bio,
    required this.profileImage,
    required this.joinDate,
    required this.workHours,
    required this.preferences,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? department,
    String? location,
    String? bio,
    String? profileImage,
    DateTime? joinDate,
    WorkHours? workHours,
    UserPreferences? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
      workHours: workHours ?? this.workHours,
      preferences: preferences ?? this.preferences,
    );
  }

  UserProfile copy() {
    return copyWith(
      workHours: workHours.copy(),
      preferences: preferences.copy(),
    );
  }
}

class WorkHours {
  final TimeRange? monday;
  final TimeRange? tuesday;
  final TimeRange? wednesday;
  final TimeRange? thursday;
  final TimeRange? friday;
  final TimeRange? saturday;
  final TimeRange? sunday;

  const WorkHours({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  WorkHours copy() {
    return WorkHours(
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
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

class UserPreferences {
  final bool notificationEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final int reminderTime; // minutes before appointment
  final String theme;
  final String language;
  final String timeFormat;

  const UserPreferences({
    required this.notificationEnabled,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.reminderTime,
    required this.theme,
    required this.language,
    required this.timeFormat,
  });

  UserPreferences copyWith({
    bool? notificationEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    int? reminderTime,
    String? theme,
    String? language,
    String? timeFormat,
  }) {
    return UserPreferences(
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      reminderTime: reminderTime ?? this.reminderTime,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }

  UserPreferences copy() {
    return copyWith();
  }
}