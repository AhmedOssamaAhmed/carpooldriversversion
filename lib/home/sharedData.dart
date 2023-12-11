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
Future<List<DocumentSnapshot>> getMyRequests() async {
  try{
    QuerySnapshot requests = await FirebaseFirestore.instance.collection('requests').get();
    return requests.docs;
  }catch(e){
    print("Error retrieving requests: $e");
    showToast(text: "can't fetch requests", error: true);
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
  // List<Map> my_finished_requests = [
  //   {1:'finished'},
  //   {4:'finished'},
  //   {3:'finished'},
  // ];
  List<Map> my_finished_requests = [];
  List<Map> all_routes = [];
  List<Map> rides_of_my_request = [];

  Future<void> fetchAvailableRoutes() async {
    try {
      String? uID = getToken();
      List<DocumentSnapshot> rides = await getRidesByHost(uID!);
      List<DocumentSnapshot> requests = await getMyRequests();
      // Update the available_routes list with the fetched rides
      availble_routes = rides.map((ride) => ride.data() as Map).toList();
      all_routes = rides.map((ride) => ride.data() as Map).toList();
      my_requests = requests.map((ride) => ride.data() as Map).toList();

      int looping_length = availble_routes.length;
      for (var i = 0; i< looping_length; i++) {
        if (availble_routes[i]["status"] == 'finished') {
          my_finished_requests.add(availble_routes[i]);
          availble_routes.removeWhere((route) => route['id'] == availble_routes[i]['id']);
          looping_length --;
        }
      }
      int requests_looping = my_requests.length;
      rides_of_my_request = [];
      for(var i=0; i<requests_looping;i++){
        print(my_requests[i]);

        bool requestExists = availble_routes.any((record) => record['id'] == my_requests[i]['id']);
        if(requestExists && my_requests[i]['status']!='finished'){
          print(requestExists);
          print("yesssssssssssssssssssssssss");
          availble_routes[i]['request_id'] = my_requests[i]['request_id'];
          rides_of_my_request.add(availble_routes[i]);

        }
      }
      print(rides_of_my_request);
      print("***************************");
      print(availble_routes);
      print("----------------------------");
      print(my_finished_requests);
      print("///////////////////////////////");
      print(my_requests);
      print("8888888888888888888888888");
      print(all_routes);
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
  Future<void> updateRequest(int requestId, Map<String, dynamic> updatedData,context) async {
    try {
      buildProgress(text: "Approving ...", context: context, error: false);
      // Replace 'requests' with your actual collection name
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('requests');

      // Find the document with the matching request_id
      QuerySnapshot querySnapshot = await requestsCollection.where('request_id', isEqualTo: requestId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first document found with the matching request_id
        DocumentReference documentReference = requestsCollection.doc(querySnapshot.docs.first.id);

        // Update the document with the provided data
        await documentReference.update(updatedData);

        print('Document with request_id $requestId updated successfully.');
        showToast(text: "status updated", error: false);
      } else {
        print('No document found with request_id $requestId.');
        showToast(text: "request not found", error: true);
      }
      hidebuildProgress(context);
    } catch (e) {
      hidebuildProgress(context);
      print('Error updating document: $e');
      showToast(text: "Failed to update status", error: true);
      // Handle error as needed
    }
  }

}