import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<Map<String, dynamic>> _roles = [];
  List<Map<String, dynamic>> _filteredRoles = [];
  
  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRoles() {
    // Simulate loading roles from a database
    Future.delayed(const Duration(seconds: 1), () {
      final roles = [
        {
          'id': '1',
          'name': 'CEO',
          'description': 'Chief Executive Officer with full system access',
          'permissions': ['all'],
          'level': 0,
          'isActive': true,
          'isDefault': false,
          'isSystem': true,
          'createdAt': DateTime.now().subtract(const Duration(days: 365)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 30)),
          'usersCount': 1,
        },
        {
          'id': '2',
          'name': 'Admin',
          'description': 'System administrator with configuration access',
          'permissions': ['admin', 'manage_users', 'manage_roles', 'manage_settings'],
          'level': 1,
          'isActive': true,
          'isDefault': false,
          'isSystem': true,
          'createdAt': DateTime.now().subtract(const Duration(days: 365)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 30)),
          'usersCount': 3,
        },
        {
          'id': '3',
          'name': 'Manager',
          'description': 'Department manager with team management capabilities',
          'permissions': ['manage_team', 'view_reports', 'manage_appointments'],
          'level': 2,
          'isActive': true,
          'isDefault': false,
          'isSystem': false,
          'createdAt': DateTime.now().subtract(const Duration(days: 180)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 15)),
          'usersCount': 8,
        },
        {
          'id': '4',
          'name': 'Employee',
          'description': 'Regular employee with basic access',
          'permissions': ['view_own_appointments', 'create_appointments'],
          'level': 3,
          'isActive': true,
          'isDefault': true,
          'isSystem': true,
          'createdAt': DateTime.now().subtract(const Duration(days: 365)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 30)),
          'usersCount': 42,
        },
        {
          'id': '5',
          'name': 'Visitor',
          'description': 'External visitor with limited access',
          'permissions': ['view_own_appointments', 'request_appointments'],
          'level': 4,
          'isActive': true,
          'isDefault': false,
          'isSystem': true,
          'createdAt': DateTime.now().subtract(const Duration(days: 365)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 30)),
          'usersCount': 156,
        },
        {
          'id': '6',
          'name': 'Project Manager',
          'description': 'Manages specific projects and related appointments',
          'permissions': ['manage_projects', 'manage_appointments', 'view_reports'],
          'level': 2,
          'isActive': true,
          'isDefault': false,
          'isSystem': false,
          'createdAt': DateTime.now().subtract(const Duration(days: 90)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 5)),
          'usersCount': 12,
        },
        {
          'id': '7',
          'name': 'Receptionist',
          'description': 'Manages front desk and visitor appointments',
          'permissions': ['manage_visitors', 'view_appointments', 'create_appointments'],
          'level': 3,
          'isActive': true,
          'isDefault': false,
          'isSystem': false,
          'createdAt': DateTime.now().subtract(const Duration(days: 120)),
          'updatedAt': DateTime.now().subtract(const Duration(days: 10)),
          'usersCount': 4,
        },
      ];

      setState(() {
        _roles = roles;
        _filteredRoles = roles;
        _isLoading = false;
      });
    });
  }

  void _filterRoles() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredRoles = _roles;
      });
      return;
    }

    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredRoles = _roles.where((role) {
        return role['name'].toString().toLowerCase().contains(query) ||
            (role['description'] != null && 
                role['description'].toString().toLowerCase().contains(query));
      }).toList();
    });
  }

  void _showRoleDialog({Map<String, dynamic>? role}) {
    final isEditing = role != null;
    final titleController = TextEditingController(text: isEditing ? role['name'] : '');
    final descriptionController = TextEditingController(
        text: isEditing ? role['description'] : '');
    final formKey = GlobalKey<FormState>();
    final List<String> selectedPermissions = isEditing 
        ? List<String>.from(role['permissions']) 
        : [];
    int level = isEditing ? role['level'] : 3;
    bool isActive = isEditing ? role['isActive'] : true;
    bool isDefault = isEditing ? role['isDefault'] : false;

    // List of all available permissions
    final allPermissions = [
      'manage_users',
      'manage_roles',
      'manage_settings',
      'manage_team',
      'view_reports',
      'manage_appointments',
      'view_own_appointments',
      'create_appointments',
      'request_appointments',
      'manage_projects',
      'manage_visitors',
      'view_appointments',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Role' : 'Create New Role'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Role Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a role name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text('Hierarchy Level:'),
                Slider(
                  value: level.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: level.toString(),
                  onChanged: isEditing && role['isSystem'] == true
                      ? null
                      : (value) {
                          level = value.toInt();
                        },
                ),
                Row(
                  children: [
                    const Text('0: Highest'),
                    const Spacer(),
                    const Text('5: Lowest'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Permissions:'),
                const SizedBox(height: 8),
                ...allPermissions.map((permission) {
                  return CheckboxListTile(
                    title: Text(permission.replaceAll('_', ' ').capitalize()),
                    value: selectedPermissions.contains(permission),
                    onChanged: isEditing && role['isSystem'] == true
                        ? null
                        : (value) {
                            if (value == true) {
                              selectedPermissions.add(permission);
                            } else {
                              selectedPermissions.remove(permission);
                            }
                          },
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('Active'),
                        value: isActive,
                        onChanged: isEditing && role['isSystem'] == true
                            ? null
                            : (value) {
                                isActive = value;
                              },
                        dense: true,
                      ),
                    ),
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('Default'),
                        value: isDefault,
                        onChanged: isEditing && role['isSystem'] == true
                            ? null
                            : (value) {
                                isDefault = value;
                              },
                        dense: true,
                      ),
                    ),
                  ],
                ),
                if (isEditing && role['isSystem'] == true)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This is a system role with limited editing capabilities.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  // Update existing role
                  final updatedRole = {
                    ...role,
                    'name': titleController.text,
                    'description': descriptionController.text,
                    'permissions': selectedPermissions,
                    'level': level,
                    'isActive': isActive,
                    'isDefault': isDefault,
                    'updatedAt': DateTime.now(),
                  };
                  
                  // Update the role in the list
                  setState(() {
                    final index = _roles.indexWhere((r) => r['id'] == role['id']);
                    if (index != -1) {
                      _roles[index] = updatedRole;
                      _filterRoles();
                    }
                  });
                } else {
                  // Create new role
                  final newRole = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': titleController.text,
                    'description': descriptionController.text,
                    'permissions': selectedPermissions,
                    'level': level,
                    'isActive': isActive,
                    'isDefault': isDefault,
                    'isSystem': false,
                    'createdAt': DateTime.now(),
                    'updatedAt': DateTime.now(),
                    'usersCount': 0,
                  };
                  
                  // Add the new role to the list
                  setState(() {
                    _roles.add(newRole);
                    _filterRoles();
                  });
                }
                
                Navigator.of(context).pop();
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing 
                          ? 'Role "${titleController.text}" updated successfully' 
                          : 'Role "${titleController.text}" created successfully'
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

  void _confirmDeleteRole(Map<String, dynamic> role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Role'),
        content: Text(
          'Are you sure you want to delete the role "${role['name']}"? '
          'This will affect ${role['usersCount']} users with this role.'
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
                _roles.removeWhere((r) => r['id'] == role['id']);
                _filterRoles();
              });
              
              Navigator.of(context).pop();
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Role "${role['name']}" deleted successfully'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Role Management Help'),
                  content: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Roles define what users can do in the system. Each role has:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Name and description'),
                        Text('• Hierarchy level (0 is highest)'),
                        Text('• Set of permissions'),
                        Text('• Active/inactive status'),
                        Text('• Default status for new users'),
                        SizedBox(height: 16),
                        Text(
                          'System roles:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Cannot be deleted'),
                        Text('• Have limited editing capabilities'),
                        Text('• Ensure core system functionality'),
                        SizedBox(height: 16),
                        Text(
                          'Custom roles:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('• Can be created, edited, and deleted'),
                        Text('• Allow for organization-specific needs'),
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
                      hintText: 'Search roles...',
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
                                  _filterRoles();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filterRoles();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRoles.isEmpty
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
                                  ? 'No roles found'
                                  : 'No roles matching "$_searchQuery"',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty) ...[  
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.clear),
                                label: const Text('Clear Search'),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _filterRoles();
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredRoles.length,
                        itemBuilder: (context, index) {
                          final role = _filteredRoles[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    role['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  if (role['isSystem'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'System',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  if (role['isDefault'] == true)
                                    Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Default',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  if (role['isActive'] == false)
                                    Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Inactive',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(role['description'] ?? 'No description'),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
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
                                          'Level: ${role['level']}',
                                          style: const TextStyle(fontSize: 12),
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
                                          '${role['usersCount']} users',
                                          style: const TextStyle(fontSize: 12),
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
                                          '${role['permissions'].length} permissions',
                                          style: const TextStyle(fontSize: 12),
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
                                    onPressed: () => _showRoleDialog(role: role),
                                    tooltip: 'Edit Role',
                                  ),
                                  if (role['isSystem'] != true)
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmDeleteRole(role),
                                      tooltip: 'Delete Role',
                                    ),
                                ],
                              ),
                              onTap: () {
                                // Show role details
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
                                                    backgroundColor: Colors.blue.shade100,
                                                    child: Text(
                                                      role['name'][0],
                                                      style: TextStyle(
                                                        color: Colors.blue.shade800,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          role['name'],
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          role['description'] ?? 'No description',
                                                          style: TextStyle(
                                                            color: Colors.grey.shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              const Text(
                                                'Role Details',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              _buildDetailRow('Hierarchy Level', 'Level ${role['level']}'),
                                              _buildDetailRow('Status', role['isActive'] ? 'Active' : 'Inactive'),
                                              _buildDetailRow(
                                                'Type', 
                                                role['isSystem'] ? 'System Role' : 'Custom Role'
                                              ),
                                              _buildDetailRow(
                                                'Default for New Users', 
                                                role['isDefault'] ? 'Yes' : 'No'
                                              ),
                                              _buildDetailRow(
                                                'Users Assigned', 
                                                '${role['usersCount']} users'
                                              ),
                                              _buildDetailRow(
                                                'Created', 
                                                _formatDate(role['createdAt'])
                                              ),
                                              _buildDetailRow(
                                                'Last Updated', 
                                                _formatDate(role['updatedAt'])
                                              ),
                                              const SizedBox(height: 24),
                                              const Text(
                                                'Permissions',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  for (final permission in role['permissions'])
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue.shade50,
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(
                                                          color: Colors.blue.shade200,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        permission.toString().replaceAll('_', ' ').capitalize(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.blue.shade800,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ElevatedButton.icon(
                                                    icon: const Icon(Icons.edit),
                                                    label: const Text('Edit Role'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _showRoleDialog(role: role);
                                                    },
                                                  ),
                                                  if (role['isSystem'] != true)
                                                    ElevatedButton.icon(
                                                      icon: const Icon(Icons.delete),
                                                      label: const Text('Delete'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _confirmDeleteRole(role);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        foregroundColor: Colors.white,
                                                      ),
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
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoleDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Create New Role',
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
            width: 150,
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}