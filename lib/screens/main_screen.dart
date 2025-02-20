import 'package:bucket_list_app/screens/add_screen.dart';
import 'package:bucket_list_app/screens/view_screen.dart';
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

      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }
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
    List<dynamic> filteredList = bucketListData
        .where((element) => !(element?["completed"] ??
            false)) // false are fall back value assigned to this code incase if element or completed doesnt exist
        .toList();
    return filteredList.isEmpty
        ? Center(child: Text("No data on bucket list"))
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: (bucketListData[index] is Map &&
                        //(bucketListData[index]["completed"] == false))
                        (!(bucketListData[index]?["completed"] ??
                            false))) // the ==false was replaced with !
                    ? ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewItemScreen(
                                index: index,
                                title: bucketListData[index]?['item'] ??
                                    "", // the question mark between the square bracket reps an argument that if the index does exist the return null no need of checking for the item
                                image: bucketListData[index]?['image'] ?? "");
                          })).then((value) {
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              bucketListData[index]?['image'] ?? ""),
                        ),
                        title: Text(bucketListData[index]?['item'] ?? ""),
                        trailing: Text(
                            bucketListData[index]?['cost'].toString() ?? ""),
                      )
                    : SizedBox(),
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBucketListScreen(
              newIndex: bucketListData.length,
            );
          })).then((value) {
            if (value == "refresh") {
              getData();
            }
          });
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
