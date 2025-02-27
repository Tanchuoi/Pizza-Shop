import '../models/product.dart';

class ProductManager {
  static List<Product> getProducts() {
    return [
      Product(
        name: "Pizza Tứ Vị Xuân",
        description: "Mực, tôm, thanh cua, thịt ba chỉ xô...",
        price: 249000,
        imageUrl: "assets/images/pizza.png", // Replace with actual image URL
      ),
      Product(
        name: "Pizza Tứ Vị Xuân (Có Viền)",
        description: "Mực, tôm, thanh cua, thịt ba chỉ xô...",
        price: 318000,
        imageUrl: "assets/images/pizza.png",
      ),
      Product(
        name: "Pizza Hải Sản",
        description: "Tôm, mực, thanh cua, sốt đặc biệt...",
        price: 289000,
        imageUrl: "assets/images/pizza.png",
      ),
      Product(
        name: "Pizza Gà Cay",
        description: "Gà cay, sốt tiêu đen, phô mai...",
        price: 259000,
        imageUrl: "assets/images/pizza.png",
      ),
      Product(
        name: "Pizza Tứ Vị Xuân",
        description: "Mực, tôm, thanh cua, thịt ba chỉ xô...",
        price: 249000,
        imageUrl: "assets/images/pizza.png", // Replace with actual image URL
      ),
      Product(
        name: "Pizza Tứ Vị Xuân (Có Viền)",
        description: "Mực, tôm, thanh cua, thịt ba chỉ xô...",
        price: 318000,
        imageUrl: "assets/images/pizza.png",
      ),
      Product(
        name: "Pizza Hải Sản",
        description: "Tôm, mực, thanh cua, sốt đặc biệt...",
        price: 289000,
        imageUrl: "assets/images/pizza.png",
      ),
      Product(
        name: "Pizza Gà Cay",
        description: "Gà cay, sốt tiêu đen, phô mai...",
        price: 259000,
        imageUrl: "assets/images/pizza.png",
      ),
    ];
  }
}
