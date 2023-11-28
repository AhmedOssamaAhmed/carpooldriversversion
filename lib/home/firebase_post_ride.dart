
import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:carpooldriversversion/home/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> postRideToFirestore(
    String from,
    String to,
    double price,
    String car,
    double seats,
    DateTime selectedDate,
    TimeOfDay selectedTime,
    context) async {
  try {
    buildProgress(text: "Adding Ride ...", context: context, error: false);
    print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
    String? uID = getToken();
    print(uID);
    String? driver = await getUserName(uID!);
    print(driver);
    await FirebaseFirestore.instance.collection('rides').add({
      'driver': driver,
      'from': from,
      'to': to,
      'price': price,
      'car': car,
      'seats': seats,
      'date': formatDate(selectedDate),
      'time': formatTimeOfDay(selectedTime),
      'status': 'available',
      'host': uID,
      'id': DateTime.now().millisecondsSinceEpoch * uID.length,
    });
    hidebuildProgress(context);
    showToast(text: "Ride Added", error: false);
    navigateAndFinish(context, bottom_navigation());
  } catch (e) {
    print("cant post ride to firestore");
    print('Error: $e');
    hidebuildProgress(context);
    showToast(text: "couldn't post ride", error: true);
  }
}
