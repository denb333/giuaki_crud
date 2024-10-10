import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_giuaki_app/main.dart';
import 'package:crud_giuaki_app/model/product.dart';
import 'package:crud_giuaki_app/model/user.dart';
import 'package:crud_giuaki_app/service/database.dart';
import 'package:crud_giuaki_app/view/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  UserModel? userData;

  Stream? productStream;

  @override
  void initState() {
    // getontheload();
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    userData = await DatabaseMethods().getCurrentUser();
    setState(
        () {}); // Gọi setState để cập nhật UI sau khi dữ liệu userData đã được lấy
    if (userData != null) {
      getontheload(); // Chỉ gọi getontheload sau khi userData đã có giá trị
    } // Call setState to update the UI after data is fetched
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Product()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hello ",
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${userData?.username}",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Add the logout icon
            onPressed: () {
              DatabaseMethods().logout(context);
            }, // Call the logout function when the icon is pressed
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Expanded(child: allProductDetail()),
          ],
        ),
      ),
    );
  }

  getontheload() async {
    productStream =
        await DatabaseMethods().getProductDetails("${userData?.email}");
    // print("email user : " + "${userData?["email"]}" );
    setState(() {});
  }

  Widget allProductDetail() {
    return StreamBuilder(
      stream: productStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  ProductModel product =
                      ProductModel.fromMap(ds.data() as Map<String, dynamic>);
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Đặt align cho hàng
                          children: [
                            // Hiển thị hình ảnh sản phẩm
                            product.imageUrl != null &&
                                    product.imageUrl!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Image.network(
                                      product
                                          .imageUrl!, // Sử dụng imageUrl từ product
                                      width: 50, // Chiều rộng của ảnh
                                      height: 50, // Chiều cao của ảnh
                                      fit: BoxFit.cover, // Cách hiển thị ảnh
                                    ),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors
                                        .grey[300], // Màu nền khi không có ảnh
                                    child: Center(
                                        child: Text(
                                            "No Image")), // Thông báo không có ảnh
                                  ),
                            SizedBox(width: 10),
                            // Khoảng cách giữa hình ảnh và nội dung
                            Expanded(
                              // Đảm bảo phần text không bị cắt
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Name: " + product.name,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          editProductDetail(product.id);
                                          nameController.text = product.name;
                                          priceController.text = product.price;
                                          typeController.text = product.type;
                                        },
                                        child: Icon(Icons.edit,
                                            color: Colors.orange),
                                      ),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () async {
                                          await DatabaseMethods()
                                              .deleteProductDetail(product.id);
                                        },
                                        child: Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: 10), // Khoảng cách giữa tên và các thông tin khác
                                  Text(
                                    "Price: ${product.price} đ" ,
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Type: " + product.type,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }

  Future editProductDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: Container(
            height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel)),
                    SizedBox(
                      width: 60,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Detail",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Name product",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Price",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Type",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: typeController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          // Map<String, dynamic> updateInfo = {
                          //    "name": nameController.text,
                          //    "price": priceController.text,
                          //   "id": id,
                          //   "type": typeController.text,
                          // };
                          ProductModel updatedProduct = ProductModel(
                            id: id,
                            name: nameController.text,
                            price: priceController.text,
                            type: typeController.text,
                            userId: userData!.email,
                          );
                          await DatabaseMethods()
                              .updateProductDetail(id, updatedProduct)
                              .then((onValue) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Update")))
              ],
            ),
          )));
}
