class SaleRequest {
  int quantity;
  double unitPrice;
  DateTime date;
  String productName;
  String catName;
  String supplierName;

  // Constructor
  SaleRequest({
    required this.quantity,
    required this.unitPrice,
    required this.date,
    required this.productName,
    required this.catName,
    required this.supplierName,
  });

  // Factory method to create a SaleRequest from JSON
  factory SaleRequest.fromJson(Map<String, dynamic> json) {
    return SaleRequest(
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      date: DateTime.parse(json['date']),
      productName: json['productName'],
      catName: json['catName'],
      supplierName: json['supplierName'],
    );
  }

  // Method to convert SaleRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'unitPrice': unitPrice,
      'date': date.toIso8601String(),
      'productName': productName,
      'catName': catName,
      'supplierName': supplierName,
    };
  }
}
