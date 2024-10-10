// class ProductModel {
//   String id;
//   String name;
//   String price;
//   String type;
//   String userId;
//
//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.type,
//     required this.userId,
//   });
//
//   // Phương thức để chuyển đổi từ Map sang ProductModel
//   factory ProductModel.fromMap(Map<String, dynamic> data) {
//     return ProductModel(
//       id: data['id'] ?? '',
//       name: data['name'] ?? '',
//       price: data['price'] ?? '',
//       type: data['type'] ?? '',
//       userId: data['userId'] ?? '',
//     );
//   }
//
//   // Phương thức để chuyển đổi từ ProductModel sang Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//       'type': type,
//       'userId': userId,
//     };
//   }
// }
class ProductModel {
  String id;
  String name;
  String price;
  String type;
  String userId;
  String? imageUrl; // Thêm thuộc tính này

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.userId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type,
      'userId': userId,
      'imageUrl': imageUrl, // Đảm bảo rằng bạn đã bao gồm imageUrl
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      type: map['type'],
      userId: map['userId'],
      imageUrl: map['imageUrl'], // Đảm bảo rằng bạn đã lấy imageUrl
    );
  }
}

