import 'package:flutter/material.dart';
import 'package:sportshop/home.dart';

class CategoryProductsPage extends StatefulWidget {
  final List<Map<String, dynamic>> allProducts;

  const CategoryProductsPage({super.key, required this.allProducts});

  @override
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late List<Map<String, dynamic>> filteredProducts;
  String currentCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.allProducts;
  }

  void filterProducts(String category) {
    setState(() {
      currentCategory = category;
      if (category == 'All') {
        filteredProducts = widget.allProducts
            .where((product) => product['Categories'] == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$currentCategory Products'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: filteredProducts.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent: 270.0,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                                product: filteredProducts[index]),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            (filteredProducts[index]['isLocal'] == false
                                ? Image.network(
                                    filteredProducts[index]['Path_Link'],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    filteredProducts[index]['Path_Link'],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )),
                            const SizedBox(height: 5),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    height: 37,
                                    child: Text(
                                      filteredProducts[index]['ItemName'] ??
                                          'No Name',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${filteredProducts[index]['Dis_Price']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: filteredProducts[index]
                                                    ['Ori_Price'] !=
                                                null
                                            ? Text(
                                                '\$${filteredProducts[index]['Ori_Price']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    decoration: TextDecoration
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
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No items available in $currentCategory category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ));
  }
}
