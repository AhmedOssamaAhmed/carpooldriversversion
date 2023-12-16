import 'dart:async';

import 'package:carpooldriversversion/Modules/login/Login.dart';
import 'package:carpooldriversversion/Shared/colors/common_colors.dart';
import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:carpooldriversversion/home/sharedData.dart';
import 'package:flutter/material.dart';

class requests extends StatefulWidget {
  const requests({super.key});

  @override
  State<requests> createState() => _requestsState();
}

class _requestsState extends State<requests> {
  final sharedData _sharedData = sharedData();


  // List<Map>? availble_routes ;
  // List<Map>? my_requests ;

  var button_color = Colors.lightGreen;
  int cartItemCount = 2;
  Timer? _timer;
  static const Duration reloadDuration = const Duration(seconds:10);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(reloadDuration, (Timer timer) {
      setState(() {});
    });
  }
  Widget build(BuildContext context) {
    // availble_routes = _sharedData.rides_of_my_request!;
    // my_requests = _sharedData.my_requests!;
    // _sharedData.fetchAvailableRoutes();
    String routeStatus;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            navigateAndFinish(context, Login());
          },
          icon: Icon(Icons.logout),
        ),
        title: appbarText("My Requests"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: mainAppColor, // Change this to the desired color
        ),
        backgroundColor: defaultColor,
      ),
      body: FutureBuilder<void>(
        future: _sharedData.fetchAvailableRoutes(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator());
            }
          else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          else if (snapshot.connectionState == ConnectionState.done){
            return Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: _sharedData.rides_of_my_request.length,
                      itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                )
                              ]
                          ),
                          child: Column(
                              children: [
                                Row(
                                    children: [
                                      captionText(_sharedData.rides_of_my_request![index]['driver']),
                                      const Spacer(),
                                      captionText(_sharedData.rides_of_my_request![index]['price'].toString()),
                                      captionText("EGP"),
                                      SizedBox(width: 20,),
                                      captionText(_sharedData.rides_of_my_request![index]['date']),

                                    ]
                                ),
                                Row(
                                  children: [
                                    Text(_sharedData.rides_of_my_request![index]['from']),
                                    const Icon(Icons.arrow_right),
                                    Text(_sharedData.rides_of_my_request![index]['to']),
                                    const Spacer(),
                                    captionText(_sharedData.rides_of_my_request![index]['time'])
                                  ],
                                ),
                                Row(
                                    children: [
                                      Text("${_sharedData.rides_of_my_request![index]['seats'].toInt()} Available Seats in ${_sharedData.rides_of_my_request![index]['car']}"),
                                      const Spacer(),

                                      Container(width: 80,height: 20,
                                        child: FloatingActionButton(
                                          onPressed: ()async{
                                            setState(() {
                                              int id = _sharedData.rides_of_my_request![index]['id'];
                                              String? status;
                                              for(var ride in _sharedData.my_requests){
                                                if(ride['id'] == id){
                                                  status = ride['status'];
                                                }
                                              }
                                              print(status);
                                              if(status == 'canceled'){
                                                return;
                                              }else{
                                              showDialog(context: context,
                                                  builder:(context) {
                                                    return AlertDialog(
                                                      title: const Text("Confirm Acceptance"),
                                                      content: const Text("choose whether to accept or reject this ride"),
                                                      actions: [
                                                        TextButton(
                                                            child: const Text("reject"),
                                                            onPressed: ()async{
                                                                await _sharedData.updateRequest(_sharedData.rides_of_my_request[index]['request_id'],{'status':'rejected'},context);
                                                                Navigator.of(context).pop();
                                                                setState(() {

                                                                });
                                                            }
                                                        ),
                                                        TextButton(
                                                            child: const Text("Confirm"),
                                                            onPressed: ()async{
                                                                await _sharedData.updateRequest(_sharedData.rides_of_my_request[index]['request_id'],{'status':'accepted'},context);
                                                                print("Accepted");
                                                                Navigator.of(context).pop();
                                                                setState(() {

                                                                });

                                                            }
                                                        )
                                                      ],
                                                    );
                                                  }
                                              );}
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          backgroundColor:  _sharedData.my_requests[index]['status'] == 'pending' ? Colors.yellow
                                              : _sharedData.my_requests[index]['status'] == 'accepted' ? Colors.blue
                                              : _sharedData.my_requests[index]['status'] == 'rejected' ? Colors.red
                                              : Colors.blueGrey,
                                          child:_sharedData.my_requests[index]['status'] == 'pending'
                                              ? const Text("Pending")
                                              : _sharedData.my_requests[index]['status'] == 'accepted'
                                              ? const Text("Accepted")
                                              : _sharedData.my_requests[index]['status'] == 'rejected'
                                              ? const Text("Rejected")
                                              : _sharedData.my_requests[index]['status'] == 'canceled'
                                              ? const Text("Canceled")
                                              : const Text("Unkonwn"),

                                        ),
                                      ), // accepting container

                                    ]
                                )
                              ]
                          )
                      )
                  )
              )

            ]);
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      )

    );
  }
}
