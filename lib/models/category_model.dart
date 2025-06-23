class CategoryModel {
  final String name;
  final String? colorHex;
  final String? iconAsset;

  CategoryModel({required this.name, this.colorHex, this.iconAsset});

  factory CategoryModel.fromName(String categoryName) {
    return CategoryModel(name: categoryName);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'colorHex': colorHex, 'iconAsset': iconAsset};
  }
}
