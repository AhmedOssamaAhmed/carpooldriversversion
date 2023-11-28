import 'package:carpooldriversversion/Modules/login/Login.dart';
import 'package:carpooldriversversion/Shared/colors/common_colors.dart';
import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:carpooldriversversion/home/sharedData.dart';
import 'package:flutter/material.dart';

class routes extends StatefulWidget {
  const routes({super.key});

  @override
  State<routes> createState() => _routesState();
}

class _routesState extends State<routes> {
  final sharedData _sharedData = sharedData();

  // List<Map>? availble_routes ;
  // List<Map>? my_requests ;

  var button_color = Colors.lightGreen;
  int cartItemCount = 2;
  @override
  Widget build(BuildContext context) {
    // availble_routes = _sharedData.availble_routes!;
    // my_requests = _sharedData.my_requests!;
    String routeStatus;
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
      ),
      body: Column(children: [
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
                      captionText(_sharedData.availble_routes![index]['price']),
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
                      Text("${_sharedData.availble_routes![index]['availble_seats'].toString()} Available Seats in ${_sharedData.availble_routes![index]['car']}"),
                      const Spacer(),

                      Container(width: 80,height: 20,
                        child: FloatingActionButton(
                          onPressed: ()async{
                            setState(() {
                              String status = getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!);
                              print(status);
                                showDialog(context: context,
                                    builder:(context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Acceptance"),
                                        content: const Text("choose whether to accept or reject this ride"),
                                        actions: [
                                          TextButton(
                                            child: const Text("reject"),
                                            onPressed: ()async{
                                              setState(() {
                                                _sharedData.my_requests[index] = {_sharedData.availble_routes![index]['id']:'rejected'};
                                                print(_sharedData.my_requests);
                                                Navigator.of(context).pop();
                                              });
                                            }
                                          ),
                                          TextButton(
                                            child: const Text("Confirm"),
                                            onPressed: ()async{
                                              setState(() {
                                                _sharedData.my_requests[index] = {_sharedData.availble_routes![index]['id']:'accepted'};
                                                print(_sharedData.my_requests);
                                                print("Accepted");
                                                Navigator.of(context).pop();
                                              });

                                            }
                                          )
                                        ],
                                      );
                                    }
                                );
                            });
                          },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                          backgroundColor:  getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!) == 'pending' ? Colors.yellow
                              : getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!) == 'accepted' ? Colors.blue
                              : getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!) == 'rejected' ? Colors.red
                              : Colors.lightGreen,
                          child:getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!) == 'pending'
                              ? const Text("Pending")
                              : getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!) == 'accepted'
                              ? const Text("Accepted")
                              : getStatusForRoute(_sharedData.availble_routes![index]['id'],_sharedData.my_requests!) == 'rejected'
                              ? const Text("Rejected")
                              : const Text("Reserve"),

                        ),
                      ), // accepting container

                    ]
                  )
                ]
              )
            )
            )
          )

      ]),
    );
  }
}
