import 'package:carpooldriversversion/home/my_rides.dart';
import 'package:carpooldriversversion/home/history.dart';
import 'package:flutter/material.dart';
import 'package:carpooldriversversion/home/addride.dart';
import 'package:carpooldriversversion/home/my_requests.dart';
import '../Modules/profile/Profile.dart';

class bottom_navigation extends StatefulWidget {
  @override
  _bottom_navigationState createState() => _bottom_navigationState();
}

class _bottom_navigationState extends State<bottom_navigation>
{
  int SelectedIndex = 0;
List<Widget> myWidgets=[
  AddRide(),
  my_rides(),
  requests(),
  history(),
  Profile(),
];
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: myWidgets[SelectedIndex],
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        useLegacyColorScheme: false,
        onTap: (index)
        {
          setState(() {
            SelectedIndex = index;
          });
        },
        currentIndex:SelectedIndex ,
        items: const [
          BottomNavigationBarItem(
            label: "Add Ride",
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            label: "My Rides",
            icon: Icon(Icons.transfer_within_a_station),
          ),
          BottomNavigationBarItem(
            label: "Requests",
            icon: Icon(Icons.pending_outlined),
          ),
          BottomNavigationBarItem(
              label: "History",
              icon: Icon(Icons.history),

          ),

          BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person)
          ),

        ],
      ),
    ),

  );
  }
}
