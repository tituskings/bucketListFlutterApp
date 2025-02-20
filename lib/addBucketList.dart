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
    var addForm = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Bucket List"),
        ),
        body: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(label: Text("Item")),
                controller: itemText,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(label: Text("Estimated Cost")),
                controller: costText,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "This must not be empty";
                  }
                  return null;
                },
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
                          onPressed: () {
                            if (addForm.currentState!.validate()) {
                              addData();
                            }
                          },
                          child: Text("Add Item"))),
                ],
              ),
            ],
          ),
        ));
  }
}
