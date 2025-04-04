import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportshop/cartpage.dart';
import 'package:sportshop/home.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://67ee47bdc11d5ff4bf790013.mockapi.io/info/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          user = json.decode(response.body);
          isLoading = false;
        });
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(userId: widget.userId),
          ));
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Cartpage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Image.asset(
          'assets/images/82sports.jpg',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20.0),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color.fromARGB(255, 177, 177, 177),
                  child:
                      const Icon(Icons.person, size: 80, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.isNotEmpty
                          ? '${user['firstname']} ${user['lastname']}'
                          : 'Guest User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.edit, size: 16, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildListTile(
                        icon: Icons.account_balance_wallet,
                        title: 'Account Balance',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountBalancePage(
                                  userId: widget.userId, user: user),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        icon: Icons.location_on,
                        title: 'Shipping Address',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShippingAddressPage(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        icon: Icons.history,
                        title: 'Transaction history',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionHistoryPage(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        icon: Icons.privacy_tip,
                        title: 'Privacy Center',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyCenterPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          // Log out action
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Log out',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}

class AccountBalancePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> user;

  const AccountBalancePage({Key? key, required this.userId, required this.user})
      : super(key: key);

  @override
  _AccountBalancePageState createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  String currency = 'USD';
  double balance = 0.0;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize balance from user data
    if (widget.user.isNotEmpty && widget.user['balance'] != null) {
      balance = double.tryParse(widget.user['balance'].toString()) ?? 0.0;
    }
  }

  void _convertCurrency() {
    setState(() {
      if (currency == 'USD') {
        balance = balance * 4100;
        currency = 'KHR';
      } else {
        balance = balance / 4100;
        currency = 'USD';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Account Balance', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${balance.toStringAsFixed(2)} $currency',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.swap_vertical_circle_outlined,
                    color: Colors.black),
                onPressed: _convertCurrency,
              ),
            ],
          ),
          Divider(height: 40, thickness: 1),
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: Colors.black),
            title: Text('Make a deposit'),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DepositWithdrawPage(
                    userId: widget.userId,
                    isDeposit: true,
                    currentBalance: balance,
                    currency: currency,
                  ),
                ),
              ).then((_) => fetchUpdatedBalance());
            },
          ),
          ListTile(
            leading: Icon(Icons.money, color: Colors.black),
            title: Text('Withdraw funds'),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DepositWithdrawPage(
                    userId: widget.userId,
                    isDeposit: false,
                    currentBalance: balance,
                    currency: currency,
                  ),
                ),
              ).then((_) => fetchUpdatedBalance());
            },
          ),
          ListTile(
            leading: Icon(Icons.discount, color: Colors.black),
            title: Text('Discount Coupons'),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            onTap: () {
              // Handle discount coupons action
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '82-Sports is e-commerce mobile application operated by ...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Latest Version 8.0.2',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchUpdatedBalance() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://67ee47bdc11d5ff4bf790013.mockapi.io/info/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final updatedUser = json.decode(response.body);
        setState(() {
          balance = double.tryParse(updatedUser['balance'].toString()) ?? 0.0;
        });
      }
    } catch (e) {
      debugPrint("Error fetching updated balance: $e");
    }
  }
}

class DepositWithdrawPage extends StatefulWidget {
  final String userId;
  final bool isDeposit;
  final double currentBalance;
  final String currency;

  const DepositWithdrawPage({
    Key? key,
    required this.userId,
    required this.isDeposit,
    required this.currentBalance,
    required this.currency,
  }) : super(key: key);

  @override
  _DepositWithdrawPageState createState() => _DepositWithdrawPageState();
}

class _DepositWithdrawPageState extends State<DepositWithdrawPage> {
  late bool isDeposit;
  String selectedCurrency = 'USD';
  TextEditingController amountController = TextEditingController();
  String selectedPaymentMethod = '';

  @override
  void initState() {
    super.initState();
    isDeposit = widget.isDeposit;
    selectedCurrency = widget.currency;
  }

  Future<void> _updateBalance(double amount) async {
    try {
      // Calculate new balance
      double newBalance = isDeposit
          ? widget.currentBalance + amount
          : widget.currentBalance - amount;

      // Update in the backend
      final response = await http.put(
        Uri.parse(
            'https://67ee47bdc11d5ff4bf790013.mockapi.io/info/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'balance': newBalance}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isDeposit
                  ? 'Deposit successful!'
                  : 'Withdrawal successful!')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update balance')),
        );
      }
    } catch (e) {
      debugPrint("Error updating balance: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  void _handlePaymentMethodTap(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm ${isDeposit ? 'Deposit' : 'Withdrawal'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Amount: ${amountController.text} $selectedCurrency'),
            Text('Method: $selectedPaymentMethod'),
            SizedBox(height: 20),
            if (!isDeposit &&
                double.tryParse(amountController.text) != null &&
                double.parse(amountController.text) > widget.currentBalance)
              Text(
                'Insufficient balance!',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final amount = double.tryParse(amountController.text) ?? 0;
              if (!isDeposit && amount > widget.currentBalance) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Insufficient balance!')),
                );
                return;
              }
              _updateBalance(amount);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String imagePath, String title) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.payment, size: 50, color: Colors.grey),
        ),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: () => _handlePaymentMethodTap(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isDeposit ? 'Deposit' : 'Withdraw',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Toggle between Deposit and Withdraw
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDeposit = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDeposit ? Colors.black : Colors.grey[300],
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20)),
                  ),
                  child: Text(
                    'Deposit',
                    style: TextStyle(
                      color: isDeposit ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDeposit = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: !isDeposit ? Colors.black : Colors.grey[300],
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(20)),
                  ),
                  child: Text(
                    'Withdraw',
                    style: TextStyle(
                      color: !isDeposit ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Amount input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Enter Amount',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  selectedCurrency,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                SizedBox(height: 20),
                if (!isDeposit)
                  Text(
                    'Available balance: ${widget.currentBalance.toStringAsFixed(2)} $selectedCurrency',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
          Divider(height: 40, thickness: 1),
          // Payment methods
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildPaymentMethod('assets/images/ABA.png', 'ABA PAY'),
                _buildPaymentMethod('assets/images/bakong.jpg', 'Bakong'),
                _buildPaymentMethod('assets/images/ACLEDA.png', 'Acleda'),
                _buildPaymentMethod('assets/images/wing.png', 'Wing'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '82-Sports is e-commerce mobile application operated by ...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Latest Version 8.0.2',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Shipping Address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.not_interested, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No Shipping Address',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddShippingAddressPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white, size: 30),
                  label: Text(
                    'Add address',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '82-Sports is e-commerce mobile application operated by ...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Latest Version 8.0.2',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddShippingAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'New Shipping Address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(label: 'Recipient', hint: 'Please enter the name'),
            SizedBox(height: 15),
            _buildTextField(label: 'Contact number', hint: 'Please enter'),
            SizedBox(height: 15),
            _buildTextField(label: 'Area', hint: 'Please select an address'),
            SizedBox(height: 15),
            _buildTextField(label: 'Detailed address', hint: 'Please enter'),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Save address action
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class GoogleMapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          37.7749,
          -122.4194,
        ), // Example coordinates (San Francisco)
        zoom: 12,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        // Handle map creation
      },
    );
  }
}

class TransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Transaction History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildTransactionCard(
                  context,
                  image: 'assets/images/cam.png',
                  title: 'Varaman Cambodia Jersey',
                  quantity: 1,
                  address: 'Phnom Penh, St.103 #089G',
                  orderId: '1005162882',
                  orderTime: '14:11:00 pm',
                ),
                _buildTransactionCard(
                  context,
                  image: 'assets/images/nike.png',
                  title: 'Nike Phantom GX2 Elite FG',
                  quantity: 2,
                  address: 'Phnom Penh, St.103 #089G',
                  orderId: '1005162882',
                  orderTime: '17:21:00 pm',
                ),
                _buildTransactionCard(
                  context,
                  image: 'assets/images/adidas.png',
                  title: 'Adidas Predator GK Gloves',
                  quantity: 1,
                  address: 'Phnom Penh, St.103 #089G',
                  orderId: '1005162882',
                  orderTime: '22:56:00 pm',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '82-Sports is e-commerce mobile application operated by ...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Latest Version 8.0.2',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context, {
    required String image,
    required String title,
    required int quantity,
    required String address,
    required String orderId,
    required String orderTime,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('Address : $address'),
            Text('Order ID : $orderId'),
            Text('Order Time : $orderTime'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: () {
          // Handle transaction details navigation
        },
      ),
    );
  }
}

class PrivacyCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'assets/images/82sports.jpg', // Replace with your logo asset
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Privacy Center',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'High Security starts with strong foundations.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildPrivacyOption(
                  icon: Icons.security,
                  title: 'Two-factor authentication',
                  onTap: () {
                    // Handle Two-factor authentication action
                  },
                ),
                _buildPrivacyOption(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () {
                    // Handle Change Password action
                  },
                ),
                _buildPrivacyOption(
                  icon: Icons.face,
                  title: 'Face-ID Verification',
                  onTap: () {
                    // Handle Face-ID Verification action
                  },
                ),
                _buildPrivacyOption(
                  icon: Icons.fingerprint,
                  title: 'Touch ID',
                  onTap: () {
                    // Handle Touch ID action
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '82-Sports is e-commerce mobile application operated by ...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Latest Version 8.0.2',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
