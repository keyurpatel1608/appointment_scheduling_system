import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  String _selectedRole = 'All';
  String _selectedStatus = 'All';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    // Simulate loading users from a database
    Future.delayed(const Duration(seconds: 1), () {
      final users = [
        {
          'id': '1',
          'name': 'John Smith',
          'email': 'john.smith@example.com',
          'role': 'CEO',
          'department': 'Executive',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 2)),
          'createdAt': DateTime.now().subtract(const Duration(days: 365)),
          'profileImage': 'https://randomuser.me/api/portraits/men/1.jpg',
        },
        {
          'id': '2',
          'name': 'Emily Johnson',
          'email': 'emily.johnson@example.com',
          'role': 'Admin',
          'department': 'IT',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 5)),
          'createdAt': DateTime.now().subtract(const Duration(days: 300)),
          'profileImage': 'https://randomuser.me/api/portraits/women/2.jpg',
        },
        {
          'id': '3',
          'name': 'Michael Brown',
          'email': 'michael.brown@example.com',
          'role': 'Manager',
          'department': 'Sales',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(days: 1)),
          'createdAt': DateTime.now().subtract(const Duration(days: 250)),
          'profileImage': 'https://randomuser.me/api/portraits/men/3.jpg',
        },
        {
          'id': '4',
          'name': 'Sarah Davis',
          'email': 'sarah.davis@example.com',
          'role': 'Employee',
          'department': 'Marketing',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 8)),
          'createdAt': DateTime.now().subtract(const Duration(days: 200)),
          'profileImage': 'https://randomuser.me/api/portraits/women/4.jpg',
        },
        {
          'id': '5',
          'name': 'David Wilson',
          'email': 'david.wilson@example.com',
          'role': 'Employee',
          'department': 'Finance',
          'status': 'Inactive',
          'lastLogin': DateTime.now().subtract(const Duration(days: 30)),
          'createdAt': DateTime.now().subtract(const Duration(days: 180)),
          'profileImage': 'https://randomuser.me/api/portraits/men/5.jpg',
        },
        {
          'id': '6',
          'name': 'Jennifer Taylor',
          'email': 'jennifer.taylor@example.com',
          'role': 'Manager',
          'department': 'HR',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 1)),
          'createdAt': DateTime.now().subtract(const Duration(days: 150)),
          'profileImage': 'https://randomuser.me/api/portraits/women/6.jpg',
        },
        {
          'id': '7',
          'name': 'Robert Anderson',
          'email': 'robert.anderson@example.com',
          'role': 'Employee',
          'department': 'IT',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(days: 2)),
          'createdAt': DateTime.now().subtract(const Duration(days: 120)),
          'profileImage': 'https://randomuser.me/api/portraits/men/7.jpg',
        },
        {
          'id': '8',
          'name': 'Lisa Martinez',
          'email': 'lisa.martinez@example.com',
          'role': 'Employee',
          'department': 'Customer Support',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 4)),
          'createdAt': DateTime.now().subtract(const Duration(days: 100)),
          'profileImage': 'https://randomuser.me/api/portraits/women/8.jpg',
        },
        {
          'id': '9',
          'name': 'James Thompson',
          'email': 'james.thompson@example.com',
          'role': 'Project Manager',
          'department': 'Engineering',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 6)),
          'createdAt': DateTime.now().subtract(const Duration(days: 90)),
          'profileImage': 'https://randomuser.me/api/portraits/men/9.jpg',
        },
        {
          'id': '10',
          'name': 'Patricia Garcia',
          'email': 'patricia.garcia@example.com',
          'role': 'Receptionist',
          'department': 'Administration',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(minutes: 30)),
          'createdAt': DateTime.now().subtract(const Duration(days: 80)),
          'profileImage': 'https://randomuser.me/api/portraits/women/10.jpg',
        },
        {
          'id': '11',
          'name': 'Thomas Rodriguez',
          'email': 'thomas.rodriguez@example.com',
          'role': 'Employee',
          'department': 'Sales',
          'status': 'Inactive',
          'lastLogin': DateTime.now().subtract(const Duration(days: 45)),
          'createdAt': DateTime.now().subtract(const Duration(days: 70)),
          'profileImage': 'https://randomuser.me/api/portraits/men/11.jpg',
        },
        {
          'id': '12',
          'name': 'Jessica Lewis',
          'email': 'jessica.lewis@example.com',
          'role': 'Employee',
          'department': 'Marketing',
          'status': 'Active',
          'lastLogin': DateTime.now().subtract(const Duration(hours: 3)),
          'createdAt': DateTime.now().subtract(const Duration(days: 60)),
          'profileImage': 'https://randomuser.me/api/portraits/women/12.jpg',
        },
      ];

      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    });
  }

  void _filterUsers() {
    List<Map<String, dynamic>> filtered = _users;

    // Apply role filter
    if (_selectedRole != 'All') {
      filtered = filtered.where((user) => user['role'] == _selectedRole).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      filtered = filtered.where((user) => user['status'] == _selectedStatus).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((user) {
        return user['name'].toString().toLowerCase().contains(query) ||
            user['email'].toString().toLowerCase().contains(query) ||
            user['department'].toString().toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredUsers = filtered;
    });
  }

  void _showFilterDialog() {
    // Get unique roles
    final roles = ['All', ..._users.map((user) => user['role'].toString()).toSet().toList()..sort()];
    
    // Status options
    final statuses = ['All', 'Active', 'Inactive'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Users'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Role:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRole = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text('Status:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: statuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _filterUsers();
                  Navigator.of(context).pop();
                },
                child: const Text('Apply'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedRole = 'All';
                    _selectedStatus = 'All';
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showUserDialog({Map<String, dynamic>? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: isEditing ? user['name'] : '');
    final emailController = TextEditingController(text: isEditing ? user['email'] : '');
    final departmentController = TextEditingController(text: isEditing ? user['department'] : '');
    final formKey = GlobalKey<FormState>();
    String selectedRole = isEditing ? user['role'] : 'Employee';
    String selectedStatus = isEditing ? user['status'] : 'Active';

    // Get unique roles
    final roles = _users.map((user) => user['role'].toString()).toSet().toList()..sort();
    if (!roles.contains('Employee')) roles.add('Employee');
    
    // Status options
    final statuses = ['Active', 'Inactive'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit User' : 'Create New User'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedRole = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: statuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedStatus = value;
                    }
                  },
                ),
                if (!isEditing) ...[  
                  const SizedBox(height: 16),
                  const Text(
                    'Note: A temporary password will be generated and sent to the user\'s email.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // In a real app, save to database
                if (isEditing) {
                  // Update existing user
                  final updatedUser = {
                    ...user,
                    'name': nameController.text,
                    'email': emailController.text,
                    'department': departmentController.text,
                    'role': selectedRole,
                    'status': selectedStatus,
                  };
                  
                  // Update the user in the list
                  setState(() {
                    final index = _users.indexWhere((u) => u['id'] == user['id']);
                    if (index != -1) {
                      _users[index] = updatedUser;
                      _filterUsers();
                    }
                  });
                } else {
                  // Create new user
                  final newUser = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text,
                    'email': emailController.text,
                    'department': departmentController.text,
                    'role': selectedRole,
                    'status': selectedStatus,
                    'lastLogin': null,
                    'createdAt': DateTime.now(),
                    'profileImage': 'https://randomuser.me/api/portraits/lego/1.jpg',
                  };
                  
                  // Add the new user to the list
                  setState(() {
                    _users.add(newUser);
                    _filterUsers();
                  });
                }
                
                Navigator.of(context).pop();
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing 
                          ? 'User "${nameController.text}" updated successfully' 
                          : 'User "${nameController.text}" created successfully'
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete the user "${user['name']}"? '
          'This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, delete from database
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
                _filterUsers();
              });
              
              Navigator.of(context).pop();
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User "${user['name']}" deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user['profileImage']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user['email'],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user['role'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user['status'] == 'Active'
                                        ? Colors.green.shade100
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user['status'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: user['status'] == 'Active'
                                          ? Colors.green.shade800
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'User Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Department', user['department']),
                  _buildDetailRow(
                    'Last Login', 
                    user['lastLogin'] != null
                        ? _formatDateTime(user['lastLogin'])
                        : 'Never'
                  ),
                  _buildDetailRow(
                    'Account Created', 
                    _formatDateTime(user['createdAt'])
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mock activity data
                  _buildActivityItem(
                    'Login',
                    user['lastLogin'] != null
                        ? _formatDateTime(user['lastLogin'])
                        : 'Never',
                    Icons.login,
                  ),
                  _buildActivityItem(
                    'Profile Updated',
                    _formatDateTime(DateTime.now().subtract(const Duration(days: 5))),
                    Icons.edit,
                  ),
                  _buildActivityItem(
                    'Password Changed',
                    _formatDateTime(DateTime.now().subtract(const Duration(days: 30))),
                    Icons.lock,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit User'),
                        onPressed: () {
                          Navigator.pop(context);
                          _showUserDialog(user: user);
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmDeleteUser(user);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.lock_reset),
                        label: const Text('Reset Password'),
                        onPressed: () {
                          Navigator.pop(context);
                          // Show password reset confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password reset link sent to ${user['email']}'
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                      ),
                      OutlinedButton.icon(
                        icon: Icon(
                          user['status'] == 'Active' ? Icons.block : Icons.check_circle,
                        ),
                        label: Text(
                          user['status'] == 'Active' ? 'Deactivate' : 'Activate',
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // Toggle user status
                          setState(() {
                            final index = _users.indexWhere((u) => u['id'] == user['id']);
                            if (index != -1) {
                              _users[index]['status'] = 
                                  user['status'] == 'Active' ? 'Inactive' : 'Active';
                              _filterUsers();
                            }
                          });
                          
                          // Show status change confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'User ${user['name']} ${user['status'] == 'Active' ? 'deactivated' : 'activated'} successfully'
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Inactive Users'),
          ],
          onTap: (index) {
            setState(() {
              _selectedStatus = index == 0 ? 'All' : 'Inactive';
              _filterUsers();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Users',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('User Management Help'),
                  content: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Management allows you to:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Create, edit, and delete user accounts'),
                        Text('• Assign roles and departments'),
                        Text('• Activate or deactivate accounts'),
                        Text('• Reset user passwords'),
                        Text('• View user activity and details'),
                        SizedBox(height: 16),
                        Text(
                          'User Roles:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Each user is assigned a role that determines their permissions'),
                        Text('• Roles can be managed in the Role Management section'),
                        SizedBox(height: 16),
                        Text(
                          'User Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Active users can log in and use the system'),
                        Text('• Inactive users cannot log in until reactivated'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _filterUsers();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filterUsers();
                      });
                    },
                  ),
                ),
                if (_selectedRole != 'All' || _selectedStatus != 'All' && _tabController.index == 0) ...[  
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedRole != 'All' && _selectedStatus != 'All'
                              ? '$_selectedRole • $_selectedStatus'
                              : _selectedRole != 'All'
                                  ? _selectedRole
                                  : _selectedStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedRole = 'All';
                              _selectedStatus = 'All';
                              _filterUsers();
                            });
                          },
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No users found'
                                  : 'No users matching "$_searchQuery"',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty || _selectedRole != 'All' || _selectedStatus != 'All') ...[  
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.clear),
                                label: const Text('Clear Filters'),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedRole = 'All';
                                    _selectedStatus = 'All';
                                    _filterUsers();
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user['profileImage']),
                              ),
                              title: Text(
                                user['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['email']),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          user['role'],
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          user['department'],
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: user['status'] == 'Active'
                                              ? Colors.green.shade100
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          user['status'],
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: user['status'] == 'Active'
                                                ? Colors.green.shade800
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showUserDialog(user: user),
                                    tooltip: 'Edit User',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDeleteUser(user),
                                    tooltip: 'Delete User',
                                  ),
                                ],
                              ),
                              onTap: () => _showUserDetails(user),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Create New User',
      ),
    );
  }
}