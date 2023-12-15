import 'package:carpooldriversversion/Modules/login/Login.dart';
import 'package:carpooldriversversion/home/firebase_post_ride.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carpooldriversversion/Shared/colors/common_colors.dart';
import 'package:carpooldriversversion/Shared/components/components.dart';


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
  List<TimeOfDay> allowedTimes = [
    TimeOfDay(hour: 7, minute: 30),
    TimeOfDay(hour: 17, minute: 30),
  ];
  bool from_read_only = false;
  bool to_read_only = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            navigateAndFinish(context, Login());
          },
          icon: Icon(Icons.logout),
        ),
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
              Container(
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
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Time",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: allowedTimes.map((TimeOfDay time) {
                        return Row(
                          children: [
                            Radio<TimeOfDay>(
                              value: time,
                              groupValue: selectedTime,
                              onChanged: (TimeOfDay? newValue) {
                                setState(() {
                                  selectedTime = newValue;
                                  if(selectedTime == TimeOfDay(hour: 7, minute: 30)){
                                    print("7:30");
                                    toController.text = "asu";
                                    fromController.text = "";
                                    to_read_only = true;
                                    from_read_only = false;
                                  }
                                  else if(selectedTime == TimeOfDay(hour: 17, minute: 30)){
                                    print("17:30");
                                    fromController.text = "asu";
                                    toController.text = "";
                                    from_read_only = true;
                                    to_read_only = false;
                                  }
                                });
                              },
                            ),
                            Text(time.format(context)),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "From",hint:"Enter start point",controller: fromController,type: TextInputType.streetAddress,readOnly: from_read_only),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "To",hint:"Enter destination",controller: toController,type: TextInputType.streetAddress,readOnly: to_read_only),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Price",hint:"50",controller: priceController,type: TextInputType.number),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Car",hint:"BMW",controller: carController,type: TextInputType.name),
              const SizedBox(height: 20,),
              defaultTextInputField(title: "Available Seats",hint:"2",controller: availableSeatsController,type: TextInputType.number),
              const SizedBox(height: 20,),
              dateFieldWithTitle("Date", selectedDate),
              // defaultTextInputField(title: "Time",hint:"3:00 PM",controller: timeController,type: TextInputType.datetime),

              // timeFieldWithTitle("Time", selectedTime),
              // defaultTextInputField(title: "Date",hint:"30/10/2023",controller: dateController,type: TextInputType.datetime),
              SizedBox(height: 20),
              defaultButton(radius:24 ,
                  fontSize: 12,
                  function: ()
                  async {
                    String from = fromController.text.trim();
                    String to = toController.text.trim();
                    double availableSeats;
                    double price;
                    try{
                      availableSeats = double.parse(availableSeatsController.text);
                      price = double.parse(priceController.text);
                    }catch(e){
                      print('price and available seats must be numbers');
                      showToast(text: "price and available seats must be numbers", error: true);
                      return;
                    }
                    String car = carController.text.trim();

                    if(from.isEmpty || to.isEmpty  || car.isEmpty  || selectedDate == null || selectedTime == null ){
                      print('please enter a valid data');
                      showToast(text: 'please enter a valid data', error: true);
                      return;
                    }else if(availableSeats > 6){
                      print('please enter a valid number of seats');
                      showToast(text: "your car can't have more than 6 available seats", error: true);
                      return;
                    }
                    else {
                      await postRideToFirestore(
                          from,
                          to,
                          price,
                          car,
                          availableSeats,
                          selectedDate!,
                          selectedTime!,
                          context);
                      fromController.clear();
                      toController.clear();
                      priceController.clear();
                      carController.clear();
                      availableSeatsController.clear();
                      selectedDate = null;
                      selectedTime = null;

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
              DateTime tomorrow = DateTime.now().add(Duration(days: 1));
              DateTime initialDate = selectedTime == TimeOfDay(hour: 7, minute: 30)
              ? tomorrow
                  : DateTime.now();
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: initialDate,
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
