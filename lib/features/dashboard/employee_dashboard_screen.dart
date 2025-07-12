import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
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
                    'Employee Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'employee@example.com',
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
              'Welcome, Employee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Here\'s your schedule for today',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildTodayOverview(),
            const SizedBox(height: 24),
            _buildSectionTitle('Today\'s Schedule'),
            const SizedBox(height: 16),
            _buildTodaySchedule(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Tasks'),
            const SizedBox(height: 16),
            _buildTasksList(),
            const SizedBox(height: 24),
            _buildSectionTitle('Team Availability'),
            const SizedBox(height: 16),
            _buildTeamAvailability(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/appointments/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            title: 'Appointments',
            value: '3',
            icon: Icons.calendar_today,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverviewCard(
            title: 'Tasks',
            value: '5',
            icon: Icons.task_alt,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverviewCard(
            title: 'Available Hours',
            value: '4.5',
            icon: Icons.access_time,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
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

  Widget _buildTodaySchedule(BuildContext context) {
    // Sample schedule data
    final schedule = [
      {
        'title': 'Team Meeting',
        'time': '09:00 AM - 10:00 AM',
        'location': 'Conference Room B',
        'type': 'meeting',
      },
      {
        'title': 'Client Call: ABC Corp',
        'time': '11:30 AM - 12:00 PM',
        'location': 'Your Desk',
        'type': 'call',
      },
      {
        'title': 'Project Review',
        'time': '02:00 PM - 03:30 PM',
        'location': 'Meeting Room 3',
        'type': 'meeting',
      },
    ];

    return Card(
      elevation: 1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: schedule.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = schedule[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item['type'] == 'meeting'
                  ? Colors.blue.shade100
                  : Colors.green.shade100,
              child: Icon(
                item['type'] == 'meeting' ? Icons.people : Icons.phone,
                color: item['type'] == 'meeting' ? Colors.blue : Colors.green,
              ),
            ),
            title: Text(item['title']!),
            subtitle: Text('${item['time']} | ${item['location']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/appointments/1'), // Sample appointment ID
          );
        },
      ),
    );
  }

  Widget _buildTasksList() {
    // Sample tasks data
    final tasks = [
      {
        'title': 'Complete project proposal',
        'deadline': 'Today, 5:00 PM',
        'priority': 'High',
        'completed': false,
      },
      {
        'title': 'Review client feedback',
        'deadline': 'Today, 3:00 PM',
        'priority': 'Medium',
        'completed': false,
      },
      {
        'title': 'Update weekly report',
        'deadline': 'Tomorrow, 10:00 AM',
        'priority': 'Medium',
        'completed': false,
      },
      {
        'title': 'Schedule team building',
        'deadline': 'Today, 1:00 PM',
        'priority': 'Low',
        'completed': true,
      },
    ];

    return Card(
      elevation: 1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return CheckboxListTile(
            value: task['completed'] as bool,
            onChanged: (value) {},
            title: Text(
              task['title']!,
              style: TextStyle(
                decoration: task['completed'] as bool
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task['completed'] as bool ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(task['deadline']!),
            secondary: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: task['priority'] == 'High'
                    ? Colors.red.shade50
                    : task['priority'] == 'Medium'
                        ? Colors.orange.shade50
                        : Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                task['priority']!,
                style: TextStyle(
                  fontSize: 12,
                  color: task['priority'] == 'High'
                      ? Colors.red
                      : task['priority'] == 'Medium'
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamAvailability() {
    // Sample team data
    final team = [
      {
        'name': 'John Smith',
        'position': 'Team Lead',
        'status': 'Available',
      },
      {
        'name': 'Sarah Johnson',
        'position': 'Designer',
        'status': 'In a meeting',
      },
      {
        'name': 'Michael Brown',
        'position': 'Developer',
        'status': 'Available',
      },
      {
        'name': 'Emily Davis',
        'position': 'QA Tester',
        'status': 'Out of office',
      },
    ];

    return Card(
      elevation: 1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: team.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final member = team[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(member['name']![0]),
            ),
            title: Text(member['name']!),
            subtitle: Text(member['position']!),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: member['status'] == 'Available'
                    ? Colors.green.shade50
                    : member['status'] == 'In a meeting'
                        ? Colors.orange.shade50
                        : Colors.red.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                member['status']!,
                style: TextStyle(
                  fontSize: 12,
                  color: member['status'] == 'Available'
                      ? Colors.green
                      : member['status'] == 'In a meeting'
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}