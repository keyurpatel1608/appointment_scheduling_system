import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;
  late ValueNotifier<List<dynamic>> _selectedEvents;
  
  // View options
  String _currentView = 'month';
  final List<String> _viewOptions = ['day', 'week', 'month'];
  
  // Filter options
  final List<String> _selectedFilters = ['Meeting', 'Interview', 'Conference'];
  final List<String> _filterOptions = [
    'Meeting',
    'Interview',
    'Conference',
    'Workshop',
    'Training',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = _getEventSource();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Normalize date to avoid time mismatch issues
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  Map<DateTime, List<dynamic>> _getEventSource() {
    // In a real app, this would fetch from a database
    // For now, we'll create some sample events
    final Map<DateTime, List<dynamic>> events = {};
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Add some events for the current month
    events[today] = [
      {
        'id': '1',
        'title': 'Team Meeting',
        'time': '10:00 AM - 11:00 AM',
        'type': 'Meeting',
        'status': 'Confirmed',
      },
      {
        'id': '2',
        'title': 'Lunch with Client',
        'time': '12:30 PM - 1:30 PM',
        'type': 'Meeting',
        'status': 'Confirmed',
      },
    ];
    
    events[today.add(const Duration(days: 1))] = [
      {
        'id': '3',
        'title': 'Project Review',
        'time': '2:00 PM - 3:30 PM',
        'type': 'Meeting',
        'status': 'Confirmed',
      },
    ];
    
    events[today.add(const Duration(days: 3))] = [
      {
        'id': '4',
        'title': 'Interview: Senior Developer',
        'time': '11:00 AM - 12:00 PM',
        'type': 'Interview',
        'status': 'Confirmed',
      },
      {
        'id': '5',
        'title': 'Product Demo',
        'time': '3:00 PM - 4:00 PM',
        'type': 'Conference',
        'status': 'Pending',
      },
    ];
    
    events[today.add(const Duration(days: 7))] = [
      {
        'id': '6',
        'title': 'Quarterly Planning',
        'time': '9:00 AM - 12:00 PM',
        'type': 'Conference',
        'status': 'Confirmed',
      },
    ];
    
    events[today.add(const Duration(days: 10))] = [
      {
        'id': '7',
        'title': 'Team Building Workshop',
        'time': 'All Day',
        'type': 'Workshop',
        'status': 'Confirmed',
      },
    ];
    
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Events'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: _filterOptions.map((filter) {
                  return CheckboxListTile(
                    title: Text(filter),
                    value: _selectedFilters.contains(filter),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedFilters.add(filter);
                        } else {
                          _selectedFilters.remove(filter);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Apply filters
                  this.setState(() {});
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.view_agenda),
            onSelected: (String view) {
              setState(() {
                _currentView = view;
                switch (view) {
                  case 'day':
                    _calendarFormat = CalendarFormat.week;
                    break;
                  case 'week':
                    _calendarFormat = CalendarFormat.week;
                    break;
                  case 'month':
                    _calendarFormat = CalendarFormat.month;
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return _viewOptions.map((String view) {
                return PopupMenuItem<String>(
                  value: view,
                  child: Text(
                    '${view[0].toUpperCase()}${view.substring(1)} View',
                    style: TextStyle(
                      fontWeight: _currentView == view ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<dynamic>(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2023, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              final events = _getEventsForDay(day);
              // Apply filters
              return events.where((event) => _selectedFilters.contains(event['type'])).toList();
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markersMaxCount: 3,
              markerDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                
                // Filter events based on selected filters
                final filteredEvents = events.where(
                  (event) => _selectedFilters.contains(event['type'])
                ).toList();
                
                if (filteredEvents.isEmpty) return null;
                
                return Positioned(
                  bottom: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    width: 6,
                    height: 6,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                // Apply filters to the selected day's events
                final filteredEvents = value.where(
                  (event) => _selectedFilters.contains(event['type'])
                ).toList();
                
                if (filteredEvents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events on ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay)}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/appointments/create'),
                          icon: const Icon(Icons.add),
                          label: const Text('Schedule New Appointment'),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return _buildEventCard(event);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/appointments/create'),
        tooltip: 'Create Appointment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final Color statusColor = event['status'] == 'Confirmed'
        ? Colors.green
        : event['status'] == 'Pending'
            ? Colors.orange
            : Colors.red;
    
    final Color typeColor = _getTypeColor(event['type']);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.go('/appointments/${event['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: typeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    event['type'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    event['time'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // View details
                      context.go('/appointments/${event['id']}');
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Meeting':
        return Colors.blue;
      case 'Interview':
        return Colors.purple;
      case 'Conference':
        return Colors.orange;
      case 'Workshop':
        return Colors.green;
      case 'Training':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}