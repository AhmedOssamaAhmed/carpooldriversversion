import 'dart:async';

import 'package:carpooldriversversion/Modules/login/Login.dart';
import 'package:carpooldriversversion/Shared/colors/common_colors.dart';
import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:carpooldriversversion/home/sharedData.dart';
import 'package:flutter/material.dart';

class my_rides extends StatefulWidget {
  const my_rides({super.key});

  @override
  State<my_rides> createState() => _my_ridesState();
}

class _my_ridesState extends State<my_rides> {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            navigateAndFinish(context, Login());
          },
          icon: Icon(Icons.logout),
        ),
        title: appbarText("My Offered Routes"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: mainAppColor, // Change this to the desired color
        ),
        backgroundColor: defaultColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.timer_sharp),
            onPressed: () async{
              await selectDateTime(context);
              print('time selected ${current_time}');
              setState(() {});
            },
          ),
        ],
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
            if(_sharedData.availble_routes!.isEmpty) {
              return Center(child: captionText("You haven't offered any rides yet"));
            } else{
            return Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: _sharedData.availble_routes!.length,
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
                                      captionText(_sharedData.availble_routes![index]['driver']),
                                      const Spacer(),
                                      captionText(_sharedData.availble_routes![index]['price'].toString()),
                                      captionText("EGP"),
                                      SizedBox(width: 20,),
                                      captionText(_sharedData.availble_routes![index]['date']),

                                    ]
                                ),
                                Row(
                                  children: [
                                    Text(_sharedData.availble_routes![index]['from']),
                                    const Icon(Icons.arrow_right),
                                    Text(_sharedData.availble_routes![index]['to']),
                                    const Spacer(),
                                    captionText(_sharedData.availble_routes![index]['time'])
                                  ],
                                ),
                                Row(
                                    children: [
                                      Text("${_sharedData.availble_routes![index]['seats'].toInt()} Available Seats in ${_sharedData.availble_routes![index]['car']}"),
                                      const Spacer(),

                                      Container(width: 80,height: 20,
                                        child: FloatingActionButton(
                                          onPressed: ()async{
                                            // setState(() {
                                              String status = _sharedData.availble_routes![index]['status'];
                                              print(status);
                                              showDialog(context: context,
                                                  builder:(context) {
                                                    return AlertDialog(
                                                      title: const Text("Confirm Removal"),
                                                      content: const Text("Are you sure you want to remove this ride ?"),
                                                      actions: [
                                                        TextButton(
                                                            child: const Text("CANCEL"),
                                                            onPressed: ()async{
                                                              setState(() {
                                                                // _sharedData.my_requests[index] = {_sharedData.availble_routes![index]['id']:'rejected'};
                                                                // print(_sharedData.my_requests);
                                                                Navigator.of(context).pop();
                                                              });
                                                            }
                                                        ),
                                                        TextButton(
                                                            child: const Text("remove"),
                                                            onPressed: ()async{
                                                                await _sharedData.removeRide(_sharedData.availble_routes![index]['id'],context);
                                                                Navigator.of(context).pop();
                                                              setState(() {
                                                              });

                                                            }
                                                        )
                                                      ],
                                                    );
                                                  }
                                              );
                                            // });
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          backgroundColor:  _sharedData.availble_routes![index]['status'] == 'pending' ? Colors.yellow
                                              : _sharedData.availble_routes![index]['status'] == 'accepted' ? Colors.blue
                                              : _sharedData.availble_routes![index]['status'] == 'rejected' ? Colors.red
                                              : Colors.lightGreen,
                                          child:_sharedData.availble_routes![index]['status'] == 'available'
                                              ? const Text("available")
                                              : _sharedData.availble_routes![index]['status'] == 'accepted'
                                              ? const Text("Accepted")
                                              : _sharedData.availble_routes![index]['status'] == 'rejected'
                                              ? const Text("Rejected")
                                              : const Text("unknown"),

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
          }
          else{
            return const Center(child: Text("You haven't offered any rides yet"));
          }
        }
      )

    );
  }
}
