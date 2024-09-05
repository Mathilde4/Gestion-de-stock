class Product {
  int productId;
  String productName;
  String productDescription;
  double price;
  int categoryId;
  bool isDeleted; // Nouvelle propriété

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.categoryId,
    this.isDeleted = false, // Initialiser à false par défaut
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      categoryId: json['categoryId'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
