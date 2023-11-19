import 'package:carpooldriversversion/home/bottom_navigation.dart';
import 'package:carpooldriversversion/home/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carpooldriversversion/Shared/colors/common_colors.dart';
import 'package:carpooldriversversion/Shared/components/components.dart';
import 'package:provider/provider.dart';

import 'ChangeNotifier.dart';

class AddRide extends StatefulWidget {
  const AddRide({Key? key}) : super(key: key);

  @override
  _AddRideState createState() => _AddRideState();
}

class _AddRideState extends State<AddRide> {
  // Use TextEditingController to get values from text fields
  TextEditingController driverController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController carController = TextEditingController();
  TextEditingController availableSeatsController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appbarText("Add Ride"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: mainAppColor, // Change this to the desired color
        ),
        backgroundColor: defaultColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Driver",hint: "Ahmed" , controller: driverController, type: TextInputType.name),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "From",hint:"Rehab",controller: fromController,type: TextInputType.streetAddress),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "To",hint:"asu",controller: toController,type: TextInputType.streetAddress),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Price",hint:"50",controller: priceController,type: TextInputType.number),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Car",hint:"BMW",controller: carController,type: TextInputType.name),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Available Seats",hint:"2",controller: availableSeatsController,type: TextInputType.number),
              const SizedBox(height: 20,),
              dateFieldWithTitle("Date", selectedDate),
              // defaultTextInputField(title: "Time",hint:"3:00 PM",controller: timeController,type: TextInputType.datetime),
              const SizedBox(height: 20,),
              timeFieldWithTitle("Time", selectedTime),
              // defaultTextInputField(title: "Date",hint:"30/10/2023",controller: dateController,type: TextInputType.datetime),
              SizedBox(height: 20),
              defaultButton(radius:24 ,
                  fontSize: 12,
                  function: ()
                  {
                    String driver = driverController.text;
                    String from = fromController.text;
                    String to = toController.text;
                    print("before price");
                    double price = double.parse(priceController.text);
                    String car = carController.text;
                    print("before available seats");
                    double availableSeats = double.parse(availableSeatsController.text);

                    if(driver.isEmpty || from.isEmpty || to.isEmpty  || car.isEmpty  || selectedDate == null || selectedTime == null || price == null || availableSeats == null){
                      print('please enter a valid data');
                      // showToast(text: 'please enter a valid data', error: true);
                      return;
                    }
                    else{
                      setState(() {
                        driverController.clear();
                        fromController.clear();
                        toController.clear();
                        priceController.clear();
                        carController.clear();
                        availableSeatsController.clear();
                        selectedDate = null;
                        selectedTime = null;
                      });
                      print("ride added");
                      }

                  },
                  text: 'add ride',
                  toUpper: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget timeFieldWithTitle(String title, TimeOfDay? selectedTime) {
    return Container(
      width: 334,
      padding: EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
        top: 10,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            offset: Offset(1, 3),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
              );

              if (pickedTime != null && pickedTime != selectedTime) {
                setState(() {
                  this.selectedTime = pickedTime;
                });
              }
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      selectedTime != null ? "${selectedTime.format(context)}" : "Select Time"),
                  Icon(Icons.access_time),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
  Widget dateFieldWithTitle(String title, DateTime? selectedDate) {
    return Container(
      width: 334,
      padding: EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
        top: 10,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            offset: Offset(1, 3),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 5),
              );

              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  this.selectedDate = pickedDate;
                });
              }
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedDate != null
                      ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                      : "Select Date"),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
