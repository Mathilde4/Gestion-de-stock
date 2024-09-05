class ProductRequest {
  int ? productId;
  String productName;
  String productDescription;
  String catName;
  double price;

  ProductRequest({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.catName,
  });

  factory ProductRequest.fromJson(Map<String, dynamic> json) {
    return ProductRequest(
      productId: json['productId'],
        productName: json['productName'],
        productDescription: json['productDescription'],
        price: json['price'],
        catName: json['catName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'catName': catName,
    };
  }
}
