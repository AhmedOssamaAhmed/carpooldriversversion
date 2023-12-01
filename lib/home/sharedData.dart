import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<DocumentSnapshot>> getRidesByHost(String uID) async {
  try {
    QuerySnapshot ridesQuery = await FirebaseFirestore.instance
        .collection('rides')
        .where('host', isEqualTo: uID)
        .get();

    return ridesQuery.docs;
  } catch (e) {
    print('Error retrieving rides: $e');
    showToast(text: "can't fetch rides", error: true);
    return [];
  }
}

String getStatusForRoute(int id,List<Map> my_requests) {
  for (var request in my_requests) {
    if (request.keys.first == id) {
      return request[id];
    }
  }
  return 'not requested'; // Default status if not found
}

class sharedData {
  List<Map> availble_routes = [
    {'driver':'Ahmed','from':'asu','to':'Nasr city','price':'50','car':'GTR','availble_seats':4,'time':'12:00','date':'1/12/2022','id':1},
    {'driver':'Hassan','from':'asu','to':'rehab','price':'80','car':'Skoda','availble_seats':1,'time':'2:00','date':'12/02/2022','id':4},
    {'driver':'Ahmed','from':'asu','to':'Maadi','price':'100','car':'toyota','availble_seats':2,'time':'1:00','date':'12/04/2022','id':3},
  ];
  List<Map> my_requests = [
    {1:'pending'},
    {4:'accepted'},
    {3:'rejected'},
  ];
  List<Map> my_finished_requests = [
    {1:'finished'},
    {4:'finished'},
    {3:'finished'},
  ];
  Future<void> fetchAvailableRoutes() async {
    try {
      String? uID = getToken();
      List<DocumentSnapshot> rides = await getRidesByHost(uID!);
      // Update the available_routes list with the fetched rides
      availble_routes = rides.map((ride) => ride.data() as Map).toList();
      print(availble_routes);
    } catch (e) {
      print('Error fetching available routes: $e');
      showToast(text: "Error Fetching rides", error: true);
    }
  }
  // remove ride by id attribute
  Future<void> removeRide(int rideID,context) async {
    try {
      buildProgress(text: "Deleting Ride ...", context: context, error: false);
      await FirebaseFirestore.instance
          .collection('rides')
          .where('id', isEqualTo: rideID).get().then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      // await fetchAvailableRoutes();
      hidebuildProgress(context);
      showToast(text: "Ride deleted", error: false);
    } catch (e) {
      hidebuildProgress(context);
      print('Error deleting ride: $e');
      showToast(text: "can't delete ride", error: true);
    }
  }

}