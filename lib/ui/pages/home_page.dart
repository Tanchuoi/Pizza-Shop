import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/managers/user_manager.dart';
import '../../data/managers/product_manager.dart';
import '../../data/models/product.dart';
import '../../data/services/product_service.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> randomProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomProducts();
  }

  Future<void> _fetchRandomProducts() async {
    final productService = ProductService();
    final products = await productService.getRandomProducts();
    setState(() {
      randomProducts = products;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userManager = Provider.of<UserManager>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildCarouselSlider(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Xin chào, ${userManager.user?.fullName?.isNotEmpty == true ? userManager.user!.fullName : 'quý khách'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildDeliveryOptions(),
              _buildRecommendedSection(),
              _buildPromotionsSection(),
              _buildContactSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        enableInfiniteScroll: true,
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: ['banner1', 'banner2', 'banner3', 'banner4'].map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/banner/$banner.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Could not load image'),
                    );
                  },
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDeliveryOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Delivery Option
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: Colors.green[600],
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giao hàng tận nơi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '91 Đ. 3 Tháng 2, Hưng Lợi, Ninh Kiều',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Thay đổi',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Takeaway Option
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.green[600], size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mua mang về',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Tìm cửa hàng gần nhất',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.green[600],
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bạn sẽ thích',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Danh sách sẽ thay đổi theo ngày',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // ✅ Show loader
              : randomProducts.isEmpty
                  ? const Center(child: Text("Không có sản phẩm nào!"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: randomProducts
                            .map((product) =>
                                _buildProductCard(context, product))
                            .toList(),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        height: 220,
        width: 160,
        margin: const EdgeInsets.only(right: 12), // Add spacing between cards
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                product.featuredImage ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/pizza.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${product.price}đ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ưu đãi khủng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Xem ưu đãi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: PageView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/banner/banner1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Liên hệ với Pizza Hut',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cần sự hỗ trợ?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '1900 1822',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Điều khoản & Điều kiện',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
