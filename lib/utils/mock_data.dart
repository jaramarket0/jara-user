import '../models/cart_item.dart';

class MockData {
  static List<CartItem> getCartItems() {
    return [
      CartItem(
        id: '1',
        name: 'Egusi',
        description: 'Lorem ipsum dolor sit amet',
        price: 15000,
        originalPrice: 2199.99,
        quantity: 1,
      ),
      CartItem(
        id: '2',
        name: 'Crayfish',
        description: 'Lorem ipsum dolor sit amet',
        price: 5000,
        quantity: 1,
      ),
      CartItem(
        id: '3',
        name: 'Assorted Meat',
        description: 'Lorem ipsum dolor sit amet',
        price: 15000,
        quantity: 1,
      ),
      CartItem(
        id: '4',
        name: 'Stock Fish',
        description: 'Lorem ipsum dolor sit amet',
        price: 15000,
        quantity: 1,
      ),
      CartItem(
        id: '5',
        name: 'Dry Fish',
        description: 'Lorem ipsum dolor sit amet',
        price: 15000,
        quantity: 1,
      ),
    ];
  }
}

