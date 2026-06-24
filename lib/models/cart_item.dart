class CartItems {
  final String name;
  final List<CartItem> cartItems;

  CartItems({required this.name, required this.cartItems});


}



class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.quantity = 1,
  });
}

