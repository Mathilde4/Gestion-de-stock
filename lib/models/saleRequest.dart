class SaleRequest {
  int quantity;
  double unitPrice;
  int receiptNumber;
  DateTime date;
  String productName;
  String catName;
  String clientName;

  // Constructor
  SaleRequest({
    required this.quantity,
    required this.unitPrice,
    required this.receiptNumber,
    required this.date,
    required this.productName,
    required this.catName,
    required this.clientName,
  });

  // Factory method to create a SaleRequest from JSON
  factory SaleRequest.fromJson(Map<String, dynamic> json) {
    return SaleRequest(
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      receiptNumber: json['receiptNumber'],
      date: DateTime.parse(json['date']),
      productName: json['productName'],
      catName: json['catName'],
      clientName: json['clientName'],
    );
  }

  // Method to convert SaleRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'unitPrice': unitPrice,
      'receiptNumber': receiptNumber,
      'date': date.toIso8601String(),
      'productName': productName,
      'catName': catName,
      'clientName': clientName,
    };
  }
}
