class Sale {
  int saleId;
  int quantity;
  double unitPrice;
  int receiptNumber;
  DateTime date;
  String clientName;
  int productId;
  int categoryId;

  // Constructor
  Sale({
    required this.saleId,
    required this.quantity,
    required this.unitPrice,
    required this.receiptNumber,
    required this.date,
    required this.clientName,
    required this.productId,
    required this.categoryId,
  });

  // Factory method to create a Sale from JSON
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      saleId: json['saleId'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      receiptNumber: json['receiptNumber'],
      date: DateTime.parse(json['date']),
      clientName: json['clientName'],
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
      'receiptNumber': receiptNumber,
      'date': date.toIso8601String(),
      'clientName': clientName,
      'productId': productId,
      'categoryId': categoryId,
    };
  }
}
