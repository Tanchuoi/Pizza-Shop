import '../models/cart_item.dart';

class CartManager {
  final List<CartItem> _items = getCarts();
  static List<CartItem> getCarts() {
    return [
      CartItem(
        id: '1',
        name: "Pizza Tứ Vị Xuân",
        description: "Mực, tôm, thanh cua, thịt ba chỉ xô...",
        price: 249000,
        quantity: 1,
        imageUrl: "assets/images/pizza.png", // Replace with actual image URL
      ),
    ];
  }

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return List.unmodifiable(_items);
  }

  List<CartItem> get productEntries {
    return List.unmodifiable(_items);
  }

  double get totalAmount {
    return _items.fold(
        0.0, (total, cartItem) => total + (cartItem.price * cartItem.quantity));
  }
}
