import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationItem> _notifications;
  bool _isLoading = true;
  String _filterType = 'All';
  final List<String> _filterOptions = ['All', 'Appointments', 'Reminders', 'System'];

  @override
  void initState() {
    super.initState();
    // Simulate loading notifications from a server
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _notifications = _getMockNotifications();
        _isLoading = false;
      });
    });
  }

  List<NotificationItem> _getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: '1',
        title: 'New appointment request',
        message: 'John Doe has requested a meeting with you tomorrow at 10:00 AM.',
        type: 'Appointments',
        isRead: false,
        timestamp: now.subtract(const Duration(minutes: 30)),
        actionable: true,
        actions: ['Accept', 'Decline', 'Reschedule'],
      ),
      NotificationItem(
        id: '2',
        title: 'Appointment reminder',
        message: 'You have a meeting with Marketing Team in 1 hour.',
        type: 'Reminders',
        isRead: true,
        timestamp: now.subtract(const Duration(hours: 2)),
        actionable: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Appointment canceled',
        message: 'Your 3:00 PM appointment with Sarah Johnson has been canceled.',
        type: 'Appointments',
        isRead: false,
        timestamp: now.subtract(const Duration(hours: 5)),
        actionable: false,
      ),
      NotificationItem(
        id: '4',
        title: 'System maintenance',
        message: 'The system will be under maintenance tonight from 2:00 AM to 4:00 AM.',
        type: 'System',
        isRead: true,
        timestamp: now.subtract(const Duration(days: 1)),
        actionable: false,
      ),
      NotificationItem(
        id: '5',
        title: 'New role assignment',
        message: 'You have been assigned the role of Team Lead in Project X.',
        type: 'System',
        isRead: false,
        timestamp: now.subtract(const Duration(days: 2)),
        actionable: false,
      ),
      NotificationItem(
        id: '6',
        title: 'Appointment rescheduled',
        message: 'Your meeting with Client XYZ has been rescheduled to Friday at 11:00 AM.',
        type: 'Appointments',
        isRead: true,
        timestamp: now.subtract(const Duration(days: 3)),
        actionable: false,
      ),
      NotificationItem(
        id: '7',
        title: 'Reminder: Complete profile',
        message: 'Please complete your profile information to improve scheduling experience.',
        type: 'Reminders',
        isRead: false,
        timestamp: now.subtract(const Duration(days: 4)),
        actionable: true,
        actions: ['Complete Now', 'Remind Later'],
      ),
    ];
  }

  List<NotificationItem> _getFilteredNotifications() {
    if (_filterType == 'All') {
      return _notifications;
    }
    return _notifications.where((notification) => notification.type == _filterType).toList();
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((notification) => notification.copyWith(isRead: true)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((notification) => notification.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification deleted')),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications = [];
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationAction(NotificationItem notification, String action) {
    // In a real app, this would trigger different actions based on the notification type and action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action: $action for notification: ${notification.title}')),
    );
    
    // Mark as read after taking action
    _markAsRead(notification.id);
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();
    final unreadCount = _notifications.where((notification) => !notification.isRead).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty) ...[  
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: _markAllAsRead,
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all notifications',
              onPressed: _clearAllNotifications,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'Filter by:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _filterOptions.map((type) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(type),
                                  selected: _filterType == type,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _filterType = type;
                                      });
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (unreadCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$unreadCount unread',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child: filteredNotifications.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return _buildNotificationCard(notification);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _filterType == 'All'
                ? 'No notifications yet'
                : 'No $_filterType notifications',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _filterType == 'All'
                ? 'You\'re all caught up!'
                : 'Check back later for $_filterType updates',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final formattedTime = _formatTimestamp(notification.timestamp);
    final Color typeColor = _getTypeColor(notification.type);
    
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteNotification(notification.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: notification.isRead ? 1 : 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _markAsRead(notification.id),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: typeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  notification.type,
                                  style: TextStyle(
                                    color: typeColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (notification.actionable && notification.actions != null) ...[  
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: notification.actions!.map((action) {
                        final isPositive = action == 'Accept' || action == 'Complete Now';
                        final isNegative = action == 'Decline';
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: OutlinedButton(
                            onPressed: () => _handleNotificationAction(notification, action),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isPositive
                                  ? Colors.green
                                  : isNegative
                                      ? Colors.red
                                      : null,
                              side: BorderSide(
                                color: isPositive
                                    ? Colors.green
                                    : isNegative
                                        ? Colors.red
                                        : Colors.blue,
                              ),
                            ),
                            child: Text(action),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Appointments':
        return Colors.blue;
      case 'Reminders':
        return Colors.orange;
      case 'System':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime timestamp;
  final bool actionable;
  final List<String>? actions;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.timestamp,
    this.actionable = false,
    this.actions,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? timestamp,
    bool? actionable,
    List<String>? actions,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
      actionable: actionable ?? this.actionable,
      actions: actions ?? this.actions,
    );
  }
}