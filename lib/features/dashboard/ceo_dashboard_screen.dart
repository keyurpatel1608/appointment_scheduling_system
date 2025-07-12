import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CEODashboardScreen extends StatelessWidget {
  const CEODashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEO Dashboard'),
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
                    'CEO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'ceo@example.com',
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
              'Welcome, CEO',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Here\'s your executive overview',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildSectionTitle('Key Metrics'),
            const SizedBox(height: 16),
            _buildMetricsChart(),
            const SizedBox(height: 24),
            _buildSectionTitle('Executive Calendar'),
            const SizedBox(height: 16),
            _buildExecutiveCalendar(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Department Performance'),
            const SizedBox(height: 16),
            _buildDepartmentPerformance(),
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
            title: 'Total Employees',
            value: '124',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Appointments Today',
            value: '8',
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Efficiency Rate',
            value: '92%',
            icon: Icons.trending_up,
            color: Colors.purple,
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
          child: const Text('View Details'),
        ),
      ],
    );
  }

  Widget _buildMetricsChart() {
    // This would typically be a chart widget
    // For now, we'll use a placeholder
    return Card(
      elevation: 1,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bar_chart,
                size: 60,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Revenue & Growth Metrics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chart visualization would appear here',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExecutiveCalendar(BuildContext context) {
    // Sample executive meetings
    final meetings = [
      {
        'title': 'Board Meeting',
        'time': '09:00 AM - 10:30 AM',
        'location': 'Conference Room A',
        'priority': 'High',
      },
      {
        'title': 'Quarterly Review',
        'time': '11:00 AM - 12:30 PM',
        'location': 'Executive Suite',
        'priority': 'High',
      },
      {
        'title': 'Investor Call',
        'time': '02:00 PM - 03:00 PM',
        'location': 'CEO Office',
        'priority': 'Medium',
      },
    ];

    return Card(
      elevation: 1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: meetings.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return ListTile(
            title: Text(meeting['title']!),
            subtitle: Text('${meeting['time']} | ${meeting['location']}'),
            trailing: Chip(
              label: Text(
                meeting['priority']!,
                style: TextStyle(
                  color: meeting['priority'] == 'High'
                      ? Colors.red
                      : Colors.orange,
                  fontSize: 12,
                ),
              ),
              backgroundColor: meeting['priority'] == 'High'
                  ? Colors.red.shade50
                  : Colors.orange.shade50,
            ),
            onTap: () => context.go('/appointments/1'), // Sample appointment ID
          );
        },
      ),
    );
  }

  Widget _buildDepartmentPerformance() {
    // Sample department data
    final departments = [
      {
        'name': 'Sales',
        'performance': '94%',
        'trend': 'up',
      },
      {
        'name': 'Marketing',
        'performance': '87%',
        'trend': 'up',
      },
      {
        'name': 'Operations',
        'performance': '92%',
        'trend': 'stable',
      },
      {
        'name': 'Customer Support',
        'performance': '89%',
        'trend': 'up',
      },
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: departments.map((dept) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      dept['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: LinearProgressIndicator(
                      value: double.parse(dept['performance']!.replaceAll('%', '')) / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        double.parse(dept['performance']!.replaceAll('%', '')) > 90
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      dept['performance']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: double.parse(dept['performance']!.replaceAll('%', '')) > 90
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                  Icon(
                    dept['trend'] == 'up'
                        ? Icons.trending_up
                        : dept['trend'] == 'down'
                            ? Icons.trending_down
                            : Icons.trending_flat,
                    color: dept['trend'] == 'up'
                        ? Colors.green
                        : dept['trend'] == 'down'
                            ? Colors.red
                            : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}