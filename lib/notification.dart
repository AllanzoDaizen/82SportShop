import 'package:flutter/material.dart';
import 'package:sportshop/cartpage.dart';
import 'package:sportshop/setting.dart';

class NotificationPage extends StatefulWidget {
  final String userId;
  
  const NotificationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample notification data
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Order Shipped',
      'message': 'Your order #12345 has been shipped and will arrive soon.',
      'time': '10 min ago',
      'read': false,
      'icon': Icons.local_shipping,
    },
    {
      'title': 'Special Offer',
      'message': 'Get 20% off on your next purchase. Limited time only!',
      'time': '1 hour ago',
      'read': false,
      'icon': Icons.discount,
    },
    {
      'title': 'Payment Received',
      'message': 'Your payment of \$25.99 for order #12345 has been received.',
      'time': '2 days ago',
      'read': true,
      'icon': Icons.payment,
    },
    {
      'title': 'Account Update',
      'message': 'Your profile information has been updated successfully.',
      'time': '1 week ago',
      'read': true,
      'icon': Icons.account_circle,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_as_unread),
            onPressed: () {
              // Mark all as read functionality
              setState(() {
                for (var notification in notifications) {
                  notification['read'] = true;
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: notification['read'] ? Colors.white : Colors.blue[50],
            child: ListTile(
              leading: Icon(
                notification['icon'],
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: notification['read'] 
                      ? FontWeight.normal 
                      : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['message']),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: notification['read']
                  ? null
                  : const Icon(Icons.circle, color: Colors.blue, size: 12),
              onTap: () {
                // Mark as read when tapped
                setState(() {
                  notification['read'] = true;
                });
                // Handle notification tap
                _handleNotificationTap(notification);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          unselectedItemColor: Colors.black, // Color for unselected items
          selectedItemColor: Colors.black, // Color for selected item
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Cartpage(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(
                    userId: widget.userId,
                  ),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: widget.userId,
                  ),
                ),
              );
            }
          },
        ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Handle different notification types
    if (notification['title'].contains('Order')) {
      // Navigate to order details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to order details')),
      );
    } else if (notification['title'].contains('Offer')) {
      // Navigate to offers page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to special offers')),
      );
    }
    // Add more cases as needed
  }
}