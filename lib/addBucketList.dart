import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketListScreen extends StatefulWidget {
  int newIndex;
  AddBucketListScreen({super.key, required this.newIndex});

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> {
  TextEditingController itemText = TextEditingController();

  TextEditingController costText = TextEditingController();

  TextEditingController imageUrlText = TextEditingController();

  Future<void> addData() async {
    try {
      Map<String, dynamic> data = {
        "item": itemText.text,
        "cost": costText.text,
        "image": imageUrlText.text,
        "completed": false,
      };

      Response response = await Dio().patch(
          "https://flutterapitest-5b281-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json",
          data: data);
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Bucket List"),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Item")),
              controller: itemText,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Estimated Cost")),
              controller: costText,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Image url")),
              controller: imageUrlText,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: addData, child: Text("Add Item"))),
              ],
            ),
          ],
        ));
  }
}
