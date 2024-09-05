class Category {
  final int ? CategoryId;
  final String CatName;
  bool isDeleted;
 

  Category({
    required this.CategoryId,
    required this.CatName,
    this.isDeleted = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      CategoryId: json['categoryId'] ,
      CatName: json['catName'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
