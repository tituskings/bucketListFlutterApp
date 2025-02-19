import 'package:bucket_list_app/addBucketList.dart';
import 'package:bucket_list_app/viewItem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;
  //get Api
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://flutterapitest-5b281-default-rtdb.firebaseio.com/bucketlist.json");

      bucketListData = response.data;
      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text("Error getting Bucket list"),
          ElevatedButton(onPressed: getData, child: Text("Try again"))
        ],
      ),
    );
  }

  Widget listDataWidget() {
    return ListView.builder(
        itemCount: bucketListData.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewItemScreen(
                      title: bucketListData[index]['item'] ?? "",
                      image: bucketListData[index]['image'] ?? "");
                }));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage:
                    NetworkImage(bucketListData[index]['image'] ?? ""),
              ),
              title: Text(bucketListData[index]['item'] ?? ""),
              trailing: Text(bucketListData[index]['cost'].toString()),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBucketListScreen();
          }));
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Bucket List"),
        actions: [
          InkWell(
              onTap: getData,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.refresh),
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : isError
                ? errorWidget()
                : listDataWidget(),
      ),
    );
  }
}
