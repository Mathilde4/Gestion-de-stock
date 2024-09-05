class Supplier {
  final int SupplierId;
  final String SupplierName;
  final String SupplierFirstName;
  final String SupplierAddress;
  final int phone;
  final double price;
  final bool isDeleted;

  Supplier({
    required this.SupplierId,
    required this.SupplierName,
    required this.SupplierFirstName,
    required this.SupplierAddress,
    required this.phone,
    required this.price,
    this.isDeleted = false,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      SupplierId: json['supplierId'],
      SupplierName: json['supplierName'],
      SupplierFirstName: json['supplierFirstName'],
      SupplierAddress: json['supplierAddress'],
      phone: json['phone'],
      price: json['price'].toDouble(),
      isDeleted: json['isDeleted'] ?? false, 
    );
  }
}
