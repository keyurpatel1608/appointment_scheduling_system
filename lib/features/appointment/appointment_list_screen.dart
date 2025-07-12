import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search appointments...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _updateSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: _updateSearchQuery,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList('upcoming'),
                _buildAppointmentList('past'),
                _buildAppointmentList('cancelled'),
              ],
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

  Widget _buildAppointmentList(String type) {
    // Sample appointment data based on type
    final List<Map<String, dynamic>> appointments = _getAppointmentsByType(type);

    // Filter appointments based on search query
    final filteredAppointments = _searchQuery.isEmpty
        ? appointments
        : appointments.where((appointment) {
            return appointment['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                appointment['with']!.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'upcoming'
                  ? Icons.event_available
                  : type == 'past'
                      ? Icons.history
                      : Icons.event_busy,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No appointments match your search'
                  : type == 'upcoming'
                      ? 'No upcoming appointments'
                      : type == 'past'
                          ? 'No past appointments'
                          : 'No cancelled appointments',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (type == 'upcoming' && _searchQuery.isEmpty)
              ElevatedButton.icon(
                onPressed: () => context.go('/appointments/create'),
                icon: const Icon(Icons.add),
                label: const Text('Schedule New Appointment'),
              ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAppointments.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _buildAppointmentCard(appointment, context);
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, BuildContext context) {
    final Color statusColor = appointment['status'] == 'Confirmed'
        ? Colors.green
        : appointment['status'] == 'Pending'
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => context.go('/appointments/${appointment['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      appointment['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      appointment['status']!,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'With: ${appointment['with']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    appointment['date']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    appointment['time']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    appointment['location']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (appointment['type'] == 'upcoming')
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement reschedule functionality
                      },
                      icon: const Icon(Icons.edit_calendar, size: 16),
                      label: const Text('Reschedule'),
                    ),
                  if (appointment['type'] == 'upcoming')
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement cancel functionality
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Appointments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Date Range'),
            _buildFilterOption('Status'),
            _buildFilterOption('Type'),
            _buildFilterOption('Location'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Apply filters
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Show specific filter options
      },
    );
  }

  List<Map<String, dynamic>> _getAppointmentsByType(String type) {
    // Sample data for different appointment types
    if (type == 'upcoming') {
      return [
        {
          'id': '1',
          'title': 'Project Kickoff Meeting',
          'with': 'John Smith',
          'date': 'May 15, 2023',
          'time': '10:00 AM - 11:00 AM',
          'location': 'Conference Room A',
          'status': 'Confirmed',
          'type': 'upcoming',
        },
        {
          'id': '2',
          'title': 'Client Presentation',
          'with': 'ABC Corporation',
          'date': 'May 17, 2023',
          'time': '2:30 PM - 4:00 PM',
          'location': 'Meeting Room 3',
          'status': 'Pending',
          'type': 'upcoming',
        },
        {
          'id': '3',
          'title': 'Team Review',
          'with': 'Development Team',
          'date': 'May 20, 2023',
          'time': '9:00 AM - 10:30 AM',
          'location': 'Conference Room B',
          'status': 'Confirmed',
          'type': 'upcoming',
        },
      ];
    } else if (type == 'past') {
      return [
        {
          'id': '4',
          'title': 'Weekly Status Update',
          'with': 'Project Manager',
          'date': 'May 8, 2023',
          'time': '11:00 AM - 12:00 PM',
          'location': 'Meeting Room 2',
          'status': 'Completed',
          'type': 'past',
        },
        {
          'id': '5',
          'title': 'Budget Review',
          'with': 'Finance Department',
          'date': 'May 5, 2023',
          'time': '3:00 PM - 4:00 PM',
          'location': 'Finance Office',
          'status': 'Completed',
          'type': 'past',
        },
      ];
    } else {
      // Cancelled appointments
      return [
        {
          'id': '6',
          'title': 'Product Demo',
          'with': 'XYZ Inc.',
          'date': 'May 10, 2023',
          'time': '1:00 PM - 2:00 PM',
          'location': 'Demo Room',
          'status': 'Cancelled',
          'type': 'cancelled',
        },
      ];
    }
  }
}