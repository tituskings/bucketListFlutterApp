import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<dynamic> bucketListData = [];
  //get Api
  Future<void> getData() async {
    try {
      Response response = await Dio().get(
          "https://flutterapitest-5b281-default-rtdb.firebaseio.com/bucketlist.json");

      bucketListData = response.data;
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bucket List"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: getData, child: Text("Get data")),
          Expanded(
            child: ListView.builder(
                itemCount: bucketListData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(bucketListData[index]['image'] ?? ""),
                      ),
                      title: Text(bucketListData[index]['item'] ?? ""),
                      trailing:
                          Text(bucketListData[index]['cost'].toString() ?? ""),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
