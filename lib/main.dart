import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:QRCodeGen/services/getdetails_service.dart';
import 'package:QRCodeGen/viewmodel/details_viewmodel.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRCodeGen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserList(title: 'QR Code Generator'),
    );
  }
}

class UserList extends StatefulWidget {
  UserList({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    getdetails().then((value) {
      detail.clear();
      setState(() {
        detail.addAll(value);
      });
    });
    super.initState();
  }

  bool list = true;
  String name = '';
  final fileUrl =
      "";
  var dio = Dio();

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Widget _listview() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 80, 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Name of user",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.red,
                          fontWeight: FontWeight.w700)),
                  Text("Age",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.red,
                          fontWeight: FontWeight.w700)),
                ]),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Details tempdetail = detail[index];
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            list = false;
                            name = tempdetail.name;
                          });
                        },
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 80, 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("${tempdetail.name}",
                                    style: TextStyle(fontSize: 18)),
                                Text("${tempdetail.age}",
                                    style: TextStyle(fontSize: 18)),
                              ]),
                        )),
                      ),
                    )
                  ]);
            },
            itemCount: detail.length,
          ),
        ],
      ),
    );
  }

  Widget _userqr(String name) {
    return Center(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 150,
                  width: 150,
                  color: Colors.black,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 1.0,
                      child: Image.asset(
                        'assets/logoQR.png',
                        scale: 3.0,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(name,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
              ),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      list = true;
                      name = '';
                    });
                  },
                  child: Text("Back to list"))
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: list ? _listview() : _userqr(name),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {
          var tempDir = await getTemporaryDirectory();
          String fullPath = tempDir.path + "/file.pdf'";
          print('full path $fullPath');
          download2(dio, fileUrl, fullPath);
        },
        child: Icon(Icons.download_rounded),
      ),
    );
  }
}
