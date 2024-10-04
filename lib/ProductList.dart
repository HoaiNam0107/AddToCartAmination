import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.manager});

  final AddToCartAnimationManager manager;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 32,
      crossAxisSpacing: 32,
      childAspectRatio: 0.8,
      padding: EdgeInsets.all(32),
      children: List.generate(
        20,
        (index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.indigo.shade300,
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    key: manager.productKeys[index],
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.indigo.shade300,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.indigo.shade400,
                      foregroundColor: Colors.indigo.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      manager.runAnimation(index);
                    },
                    child: Text("Add to card",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.indigo.shade100,
                        )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      elevation: 0,
      backgroundColor: Colors.yellow.shade600,
      foregroundColor: Colors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: () {},
      child: Icon(Icons.shopping_cart),
    );
  }
}
