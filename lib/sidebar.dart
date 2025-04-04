import 'package:flutter/material.dart';
import 'package:sportshop/categories.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onCategorySelected;

  const Sidebar({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: Drawer(
        child: ListView(
          children: [
            const SizedBox(
              height: 80.0,
              child: DrawerHeader(
                decoration: BoxDecoration(),
                child: Center(
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.checkroom),
              title: const Text('Jersey'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryProductsPage(
                      allProducts: [],
                    ),
                  ),
                ); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.checkroom),
              title: const Text('Jacket'),
              onTap: () {
                onCategorySelected('Jacket');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_tennis),
              title: const Text('Tennis'),
              onTap: () {
                onCategorySelected('Tennis');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_baseball),
              title: const Text('Ball'),
              onTap: () {
                onCategorySelected('Ball');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_martial_arts),
              title: const Text('Material'),
              onTap: () {
                onCategorySelected('Material');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
