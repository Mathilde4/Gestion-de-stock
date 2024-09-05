class Sale {
  int saleId;
  int quantity;
  double unitPrice;
  DateTime date;
  int supplierId;
  int productId;
  int categoryId;

  // Constructor
  Sale({
    required this.saleId,
    required this.quantity,
    required this.unitPrice,
    required this.date,
    required this.supplierId,
    required this.productId,
    required this.categoryId,
  });

  // Factory method to create a Sale from JSON
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      saleId: json['saleId'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      date: DateTime.parse(json['date']),
      supplierId: json['supplierId'],
      productId: json['productId'],
      categoryId: json['categoryId'],
    );
  }

  // Method to convert Sale to JSON
  Map<String, dynamic> toJson() {
    return {
      'saleId': saleId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'date': date.toIso8601String(),
      'supplierId': supplierId,
      'productId': productId,
      'categoryId': categoryId,
    };
  }
}
