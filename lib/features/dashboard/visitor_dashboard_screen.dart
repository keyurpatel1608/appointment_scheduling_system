import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VisitorDashboardScreen extends StatelessWidget {
  const VisitorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Visitor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'visitor@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('My Appointments'),
              onTap: () {
                Navigator.pop(context);
                context.go('/appointments');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO: Implement logout logic
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Visitor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your appointments easily',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Upcoming Appointments'),
            const SizedBox(height: 16),
            _buildUpcomingAppointments(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Available Time Slots'),
            const SizedBox(height: 16),
            _buildAvailableTimeSlots(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Company Information'),
            const SizedBox(height: 16),
            _buildCompanyInfo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/appointments/create'),
        tooltip: 'Schedule New Appointment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.add_circle,
              label: 'New Appointment',
              onTap: () => context.go('/appointments/create'),
            ),
            _buildActionButton(
              icon: Icons.history,
              label: 'History',
              onTap: () => context.go('/appointments'),
            ),
            _buildActionButton(
              icon: Icons.calendar_today,
              label: 'Calendar',
              onTap: () => context.go('/calendar'),
            ),
            _buildActionButton(
              icon: Icons.help_outline,
              label: 'Help',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointments(BuildContext context) {
    // Sample appointment data
    final appointments = [
      {
        'title': 'Meeting with HR',
        'date': 'Today',
        'time': '02:30 PM',
        'status': 'Confirmed',
      },
      {
        'title': 'Product Demo',
        'date': 'Tomorrow',
        'time': '10:00 AM',
        'status': 'Pending',
      },
      {
        'title': 'Follow-up Discussion',
        'date': 'May 15, 2023',
        'time': '03:15 PM',
        'status': 'Confirmed',
      },
    ];

    return Card(
      elevation: 1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: appointments.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.event,
                color: Colors.blue,
              ),
            ),
            title: Text(appointment['title']!),
            subtitle: Text('${appointment['date']} at ${appointment['time']}'),
            trailing: Chip(
              label: Text(
                appointment['status']!,
                style: TextStyle(
                  color: appointment['status'] == 'Confirmed'
                      ? Colors.green
                      : Colors.orange,
                  fontSize: 12,
                ),
              ),
              backgroundColor: appointment['status'] == 'Confirmed'
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
            ),
            onTap: () => context.go('/appointments/1'), // Sample appointment ID
          );
        },
      ),
    );
  }

  Widget _buildAvailableTimeSlots(BuildContext context) {
    // Sample time slots
    final timeSlots = [
      {
        'date': 'Today',
        'slots': ['3:30 PM', '4:00 PM', '4:30 PM'],
      },
      {
        'date': 'Tomorrow',
        'slots': ['9:00 AM', '11:30 AM', '2:00 PM', '3:30 PM'],
      },
      {
        'date': 'May 15, 2023',
        'slots': ['10:00 AM', '1:00 PM', '4:00 PM'],
      },
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: timeSlots.map((day) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day['date']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (day['slots'] as List<String>).map((slot) {
                    return InkWell(
                      onTap: () => context.go('/appointments/create'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.business, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'ABC Corporation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, '123 Business Street, Suite 456, City, State 12345'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, '+1 (555) 123-4567'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, 'contact@abccorp.com'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, 'Business Hours: Mon-Fri, 9:00 AM - 5:00 PM'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('View Company Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}