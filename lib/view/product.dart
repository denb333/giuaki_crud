import 'dart:io';

import 'package:crud_giuaki_app/model/product.dart';
import 'package:crud_giuaki_app/model/user.dart';
import 'package:crud_giuaki_app/service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  UserModel? userData ;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  void fetchUserData() async {
    userData = await DatabaseMethods().getCurrentUser();
    setState(() {});  // Call setState to update the UI after data is fetched
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add", style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),),
            Text("Form", style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 30 , right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name product", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Price", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Type", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextField(
                    controller: typeController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  //   child: _selectedImage != null
                  //       ? ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  //   )
                  //       : Center(child: Text("Tap to select image")),
                  // ),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : Center(child: Text("Choose image")),
                  ),
                ),
                // SizedBox(height: 40),
                SizedBox(height: 40,),
                Center(child: ElevatedButton(onPressed: ()async{
                  String id = randomAlphaNumeric(5);
                  String? imageUrl = await _uploadImage(id);
                  // await _uploadImage(id);
                  ProductModel productInfoMap = ProductModel(
                    id: id,
                    name: nameController.text,
                    price: priceController.text,
                    type: typeController.text,
                    userId: userData!.email,
                    imageUrl: imageUrl,// Giữ nguyên email làm userId
                  );
                  await DatabaseMethods().addProductDetails(productInfoMap, id).then((onValue){
                    Fluttertoast.showToast(
                        msg: "Prodcut details has been uploaded successfull",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  });
                  try {
                    // Your async operations here
                    nameController.clear();
                    priceController.clear();
                    typeController.clear();
                    setState(() {
                      _selectedImage = null;
                    });
                  } catch (e) {
                    print(e);
                  }
                }, child: Text("Add", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,), )))
              ],
            ),
          ),
      ),
    );
  }
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "No image selected");
      }
    });
  }

  Future<String?> _uploadImage(String productId) async {
    if (_selectedImage == null) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('products')
          .child(productId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // Lấy URL của ảnh
    } catch (e) {
      Fluttertoast.showToast(msg: "Image upload failed: $e");
      return null;
    }
  }

}
