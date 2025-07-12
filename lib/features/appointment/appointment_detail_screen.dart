import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late Map<String, dynamic> _appointmentDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
  }

  Future<void> _loadAppointmentDetails() async {
    // Simulate loading data from a database
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real app, this would fetch data from a backend service
    setState(() {
      _appointmentDetails = _getMockAppointmentDetails(widget.appointmentId);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          if (!_isLoading && _appointmentDetails['status'] == 'Confirmed' || _appointmentDetails['status'] == 'Pending')
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // Navigate to edit screen
                    break;
                  case 'reschedule':
                    _showRescheduleDialog();
                    break;
                  case 'cancel':
                    _showCancelDialog();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'reschedule',
                  child: Row(
                    children: [
                      Icon(Icons.event),
                      SizedBox(width: 8),
                      Text('Reschedule'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'cancel',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Cancel', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(),
                  const SizedBox(height: 24),
                  _buildAppointmentHeader(),
                  const SizedBox(height: 24),
                  _buildAppointmentDetails(),
                  const SizedBox(height: 24),
                  _buildParticipantsSection(),
                  const SizedBox(height: 24),
                  _buildNotesSection(),
                  const SizedBox(height: 24),
                  _buildAttachmentsSection(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBanner() {
    final Color statusColor = _getStatusColor(_appointmentDetails['status']);
    final IconData statusIcon = _getStatusIcon(_appointmentDetails['status']);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appointmentDetails['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (_appointmentDetails['statusMessage'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _appointmentDetails['statusMessage'],
                      style: TextStyle(
                        color: statusColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _appointmentDetails['title'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.category, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              _appointmentDetails['type'],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppointmentDetails() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today, 'Date', _appointmentDetails['date']),
            const Divider(height: 24),
            _buildDetailRow(Icons.access_time, 'Time', _appointmentDetails['time']),
            const Divider(height: 24),
            _buildDetailRow(Icons.timelapse, 'Duration', _appointmentDetails['duration']),
            const Divider(height: 24),
            _buildDetailRow(Icons.location_on, 'Location', _appointmentDetails['location']),
            if (_appointmentDetails['locationDetails'] != null) ...[              
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  _appointmentDetails['locationDetails'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Participants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('3 People'),
                  backgroundColor: Colors.blue,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._appointmentDetails['participants'].map<Widget>((participant) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        participant['name'].substring(0, 1),
                        style: TextStyle(color: Colors.blue.shade800),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            participant['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            participant['role'],
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (participant['status'] != null)
                      Chip(
                        label: Text(participant['status']),
                        backgroundColor: participant['status'] == 'Confirmed'
                            ? Colors.green.shade100
                            : participant['status'] == 'Pending'
                                ? Colors.orange.shade100
                                : Colors.red.shade100,
                        labelStyle: TextStyle(
                          color: participant['status'] == 'Confirmed'
                              ? Colors.green.shade800
                              : participant['status'] == 'Pending'
                                  ? Colors.orange.shade800
                                  : Colors.red.shade800,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    // TODO: Implement edit notes functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _appointmentDetails['notes'] ?? 'No notes added yet.',
              style: TextStyle(
                color: _appointmentDetails['notes'] == null ? Colors.grey : null,
                fontStyle: _appointmentDetails['notes'] == null ? FontStyle.italic : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    final attachments = _appointmentDetails['attachments'] as List<Map<String, dynamic>>?;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attachments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    // TODO: Implement add attachment functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (attachments == null || attachments.isEmpty)
              const Text(
                'No attachments added yet.',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _getFileIcon(attachment['type']),
                      color: Colors.blue.shade700,
                    ),
                    title: Text(attachment['name']),
                    subtitle: Text(
                      '${attachment['size']} • ${attachment['uploadedBy']} • ${attachment['date']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download, size: 20),
                      onPressed: () {
                        // TODO: Implement download functionality
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_appointmentDetails['status'] == 'Cancelled' || 
        _appointmentDetails['status'] == 'Completed') {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // Clone this appointment to create a new one
            context.go('/appointments/create', extra: {'cloneFrom': widget.appointmentId});
          },
          icon: const Icon(Icons.copy),
          label: const Text('Clone Appointment'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_appointmentDetails['status'] == 'Confirmed')
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement check-in functionality
            },
            icon: const Icon(Icons.login),
            label: const Text('Check In'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        OutlinedButton.icon(
          onPressed: () {
            _showRescheduleDialog();
          },
          icon: const Icon(Icons.event),
          label: const Text('Reschedule'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement join meeting functionality
          },
          icon: const Icon(Icons.videocam),
          label: const Text('Join Meeting'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  void _showRescheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date picker would go here
            const TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            // Time picker would go here
            const TextField(
              decoration: InputDecoration(
                labelText: 'Time',
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 16),
            // Duration picker
            const TextField(
              decoration: InputDecoration(
                labelText: 'Duration',
                prefixIcon: Icon(Icons.timelapse),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement reschedule functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment rescheduled successfully')),
              );
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this appointment?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Reason for cancellation',
                hintText: 'Optional',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement cancel functionality
              Navigator.pop(context);
              setState(() {
                _appointmentDetails['status'] = 'Cancelled';
                _appointmentDetails['statusMessage'] = 'Cancelled by you';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Confirmed':
        return Icons.check_circle;
      case 'Pending':
        return Icons.pending;
      case 'Cancelled':
        return Icons.cancel;
      case 'Completed':
        return Icons.task_alt;
      default:
        return Icons.info;
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Map<String, dynamic> _getMockAppointmentDetails(String id) {
    // In a real app, this would fetch from a database or API
    return {
      'id': id,
      'title': 'Project Kickoff Meeting',
      'type': 'Business Meeting',
      'date': 'Monday, May 15, 2023',
      'time': '10:00 AM - 11:00 AM',
      'duration': '1 hour',
      'location': 'Conference Room A',
      'locationDetails': 'Building 3, Floor 2, Room 201',
      'status': 'Confirmed',
      'statusMessage': 'All participants have confirmed',
      'notes': 'Bring the project proposal documents and the preliminary budget report. We will discuss the project timeline and resource allocation.',
      'participants': [
        {
          'name': 'John Smith',
          'role': 'Project Manager',
          'status': 'Confirmed',
        },
        {
          'name': 'Sarah Johnson',
          'role': 'Lead Developer',
          'status': 'Confirmed',
        },
        {
          'name': 'Michael Brown',
          'role': 'Client Representative',
          'status': 'Pending',
        },
      ],
      'attachments': [
        {
          'name': 'Project_Proposal.pdf',
          'type': 'pdf',
          'size': '2.4 MB',
          'uploadedBy': 'John Smith',
          'date': 'May 10, 2023',
        },
        {
          'name': 'Budget_Estimate.xlsx',
          'type': 'xlsx',
          'size': '1.1 MB',
          'uploadedBy': 'Sarah Johnson',
          'date': 'May 12, 2023',
        },
      ],
    };
  }
}