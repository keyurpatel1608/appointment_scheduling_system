import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
                    'Admin User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'admin@example.com',
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
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                context.go('/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Appointments'),
              onTap: () {
                Navigator.pop(context);
                context.go('/appointments');
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                'Administration',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Role Management'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/roles');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Company Settings'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/company-settings');
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
              'Welcome, Admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Here\'s what\'s happening today',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Appointments'),
            const SizedBox(height: 16),
            _buildRecentAppointments(context),
            const SizedBox(height: 24),
            _buildSectionTitle('System Status'),
            const SizedBox(height: 16),
            _buildSystemStatus(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/appointments/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Users',
            value: '124',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Today\'s Appointments',
            value: '8',
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Pending Requests',
            value: '3',
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
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

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          icon: Icons.add_circle,
          label: 'New User',
          onTap: () => context.go('/admin/users'),
        ),
        _buildActionButton(
          icon: Icons.calendar_month,
          label: 'New Appointment',
          onTap: () => context.go('/appointments/create'),
        ),
        _buildActionButton(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () => context.go('/admin/company-settings'),
        ),
        _buildActionButton(
          icon: Icons.analytics,
          label: 'Reports',
          onTap: () {},
        ),
      ],
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

  Widget _buildRecentAppointments(BuildContext context) {
    // Sample appointment data
    final appointments = [
      {
        'name': 'John Doe',
        'time': '09:00 AM',
        'purpose': 'Interview',
        'status': 'Confirmed',
      },
      {
        'name': 'Jane Smith',
        'time': '10:30 AM',
        'purpose': 'Project Review',
        'status': 'Pending',
      },
      {
        'name': 'Robert Johnson',
        'time': '01:15 PM',
        'purpose': 'Consultation',
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
            title: Text(appointment['name']!),
            subtitle: Text('${appointment['time']} - ${appointment['purpose']}'),
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

  Widget _buildSystemStatus() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusItem(
              label: 'System Status',
              value: 'Online',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const Divider(),
            _buildStatusItem(
              label: 'Last Backup',
              value: 'Today, 03:30 AM',
              icon: Icons.backup,
              color: Colors.blue,
            ),
            const Divider(),
            _buildStatusItem(
              label: 'Storage Usage',
              value: '42%',
              icon: Icons.storage,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}