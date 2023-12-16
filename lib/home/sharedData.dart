import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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


// String getStatusForRoute(int id,List<Map> my_requests) {
//   for (var request in my_requests) {
//     if (request['id'] == id) {
//       return request['id'];
//     }
//   }
//   return 'not requested'; // Default status if not found
// }

class sharedData {
  List<Map> availble_routes = [];
  List<Map> my_requests = [];
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
        }
      }
      availble_routes.removeWhere((route) => route['status'] == 'finished');
      int requests_looping = my_requests.length;
      rides_of_my_request = [];
      for(var i=0; i<requests_looping;i++){
        bool requestExists = availble_routes.any((record) => record['id'] == my_requests[i]['id']);
        if(requestExists && my_requests[i]['status']!='finished'){
          availble_routes[i]['request_id'] = my_requests[i]['request_id'];
          rides_of_my_request.add(availble_routes[i]);

        }
      }
      DateTime current_time = DateTime.now();

      for(var ride in rides_of_my_request){
        DateTime ride_timing = getDateTimeFromString(ride['date'], ride['time']);
        if(ride['time'] == '07:30'){
          ride_timing = ride_timing.subtract(Duration(hours: 8));
          print("c:${current_time},r:${ride_timing}");
          if(current_time.isAfter(ride_timing)){
            updateRequestNoContext(ride['request_id'], {'status':'canceled'});
          }
        }
        if(ride['time'] == '17:30'){
          ride_timing = ride_timing.subtract(Duration(hours: 1));
          print("c:${current_time},r:${ride_timing}");
          if(current_time.isAfter(ride_timing)){
            updateRequestNoContext(ride['request_id'], {'status':'canceled'});
          }
        }
      }


    } catch (e) {
      print('Error fetching available routes: $e');
      showToast(text: "Error Fetching rides", error: true);
    }
  }
  // remove ride by id attribute
  Future<void> removeRide(int rideID,context) async { //FIXME cascade deleting the ride to deleting all the requests to this ride
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
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot querySnapshot = await requestsCollection.where('request_id', isEqualTo: requestId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference = requestsCollection.doc(querySnapshot.docs.first.id);
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
    }
  }
  Future<void> updateRequestNoContext(int requestId, Map<String, dynamic> updatedData) async {
    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('requests');
      QuerySnapshot querySnapshot = await requestsCollection.where('request_id', isEqualTo: requestId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference = requestsCollection.doc(querySnapshot.docs.first.id);
        await documentReference.update(updatedData);

        print('Document with request_id $requestId updated successfully.');
        // showToast(text: "status updated", error: false);
      } else {
        print('No document found with request_id $requestId.');
        // showToast(text: "request not found", error: true);
      }
    } catch (e) {
      print('Error updating document: $e');
      // showToast(text: "Failed to update status", error: true);
    }
  }
  Future<void> updateRide(int rideId, Map<String, dynamic> updatedData) async {
    try {
      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('rides');
      QuerySnapshot querySnapshot = await requestsCollection.where('id', isEqualTo: rideId).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference = requestsCollection.doc(querySnapshot.docs.first.id);
        await documentReference.update(updatedData);

        print('Document with id $rideId updated successfully.');
        // showToast(text: "status updated", error: false);
      } else {
        print('No document found with id $rideId.');
        // showToast(text: "request not found", error: true);
      }
    } catch (e) {
      print('Error updating document: $e');
      // showToast(text: "Failed to update status", error: true);
    }
  }
  DateTime getDateTimeFromString(String date,String time){
    return DateTime.parse('$date $time');
  }

}