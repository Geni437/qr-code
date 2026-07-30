import 'package:flutter/material.dart';

/// Temporary stub for the public `/view/:productId` route. The real 3D
/// viewer + product info panel is built in a later phase.
class ProductViewPlaceholderPage extends StatelessWidget {
  const ProductViewPlaceholderPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: Center(child: Text('Viewer for product $productId coming soon')),
    );
  }
}
