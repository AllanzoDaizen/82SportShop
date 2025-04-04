import 'package:flutter/material.dart';
import 'package:sportshop/cartpage.dart';
import 'package:sportshop/categories.dart';
import 'package:sportshop/notification.dart';
import 'package:sportshop/setting.dart';
import 'package:sportshop/sidebar.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SportShop',
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const Homepage(),
//     );
//   }
// }

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> cardData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://67e251cd97fc65f535356bbc.mockapi.io/api/version1/Bopha'));

    if (response.statusCode == 200) {
      setState(() {
        cardData = json.decode(response.body);
      });
    } else {
      debugPrint("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final List<Map<String, dynamic>> allProducts = [];

    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        drawer: Sidebar(
          onCategorySelected: (category) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductsPage(
                  allProducts: allProducts,
                ),
              ),
            );
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 50.0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.category,
                size: 30,
              ),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.person, size: 30),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Swiper Section
              SizedBox(
                height: 200.0,
                child: Swiper(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> imgList = [
                      'https://i0.wp.com/everydaynewsgh.com/wp-content/uploads/2021/09/F88AAE6C-23BD-432F-9042-05E18BDF504F.jpeg?ssl=1',
                      'https://3.bp.blogspot.com/-8nhmdMC5Wss/VzwuctrBynI/AAAAAAAABjk/zx5saLyf3UAb87l79mCi6VUsKdRmQbvIwCHM/s1600/lionel-messi-set-to-break-cristiano-ronaldos-heart-by-bagging.jpg',
                      'https://static.footballtransfers.com/images/cn/image/upload/q_75,w_1200,h_675,ar_16.9/footballcritic/rqvjpq63zktqvwfhj6h0.webp',
                    ];
                    return GestureDetector(
                      onTap: () {
                        print("Tapped on image: $index");
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            imgList[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 20.0,
                            left: 20.0,
                            child: Text(
                              'SHOP NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  autoplay: true,
                ),
              ),
              const SizedBox(height: 30),

              // Best Selling Text
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'BEST SELLING',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (cardData.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsPage(product: cardData[0]),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Grid of Cards
              cardData.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No items available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 10.0,
                          mainAxisExtent: 270.0,
                        ),
                        itemCount: cardData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(
                                      product: cardData[index]),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  (cardData[index]['isLocal'] == false
                                      ? Image.network(
                                          cardData[index]['Path_Link'],
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          cardData[index]['Path_Link'],
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )),
                                  const SizedBox(height: 5),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          height: 37,
                                          child: Text(
                                            cardData[index]['ItemName'] ??
                                                'No Name',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '\$${cardData[index]['Dis_Price']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: cardData[index]
                                                          ['Ori_Price'] !=
                                                      null
                                                  ? Text(
                                                      '\$${cardData[index]['Ori_Price']}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ],
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
                    ),
            ],
          ),
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
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product['selectedSize'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.product['isLocal'] == false
                  ? Image.network(
                      widget.product['Path_Link'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.asset(
                      widget.product['Path_Link'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            SizedBox(height: 4),
            Text(
              widget.product['Categories'] ?? 'No description available',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.product['ItemName'] ?? 'Unknown Product',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Product Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.product['Details'] ??
                  'No additional details available for this product.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Choose Size',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: (widget.product['Categories'] == 'Jersey'
                      ? ['S', 'M', 'L', 'XL', 'XXL']
                      : widget.product['Categories'] == 'Shoes'
                          ? [
                              "39",
                              "39.5",
                              "40",
                              "40.5",
                              "41",
                              "41.5",
                              "42",
                              "42.5",
                              "43",
                              "43.5",
                              "44",
                              "44.5",
                              "45",
                              "45.5",
                              "46"
                            ]
                          : widget.product['Categories'] == 'Jacket'
                              ? ['S', 'M', 'L', 'XL', 'XXL']
                              : widget.product['Categories'] == 'Ball'
                                  ? ['Size 1', 'Size 2', 'Size 3']
                                  : widget.product['Categories'] == 'Material'
                                      ? ['S', 'M', 'L']
                                      : ['S', 'M', 'L'])
                  .map((size) {
                return ChoiceChip(
                  label: Text(size),
                  selected: selectedSize == size,
                  selectedColor: Colors.black,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: selectedSize == size ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        selectedSize = size;
                        widget.product['selectedSize'] = size;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (widget.product['amount'] == null) {
                                widget.product['amount'] = 1;
                              }
                              if (widget.product['amount'] > 1) {
                                widget.product['amount']--;
                              }
                            });
                          },
                        ),
                      ),
                      Text(
                        '${widget.product['amount'] ?? 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if (widget.product['amount'] == null) {
                                widget.product['amount'] = 1;
                              }
                              widget.product['amount']++;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${((double.tryParse(widget.product['Dis_Price'].toString()) ?? 0) * (widget.product['amount'] ?? 1)).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedSize == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Please select a size before adding to cart'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added to cart successfully'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                  SnackBar(
                    content: Text('Added to cart successfully'),
                    duration: Duration(seconds: 1),
                  );
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
