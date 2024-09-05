class InventoryResult {
  final String productName;
  final String categoryName;
  final int purchaseQuantity;
  final int salesQuantity;
  final int remainingQuantity;

  InventoryResult({
    required this.productName,
    required this.categoryName,
    required this.purchaseQuantity,
    required this.salesQuantity,
    required this.remainingQuantity,
  });

  factory InventoryResult.fromJson(Map<String, dynamic> json) {
    return InventoryResult(
      productName: json['productName'],
      categoryName: json['categoryName'],
      purchaseQuantity: json['purchaseQuantity'],
      salesQuantity: json['salesQuantity'],
      remainingQuantity: json['remainingQuantity'],
    );
  }
}
