import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/util/smart_device_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // List of Smart Devices
  List<List> mySmartDevices = [
    ["Smart Light", "lib/icons/light-bulb.png", false],
    ["Smart AC", "lib/icons/air-conditioner.png", false],
    ["Smart TV", "lib/icons/smart-tv.png", false],
    ["Smart Fan", "lib/icons/fan.png", false],
  ];

  @override
  void initState() {
    super.initState();
    getDevicesStatus().then((value) {
      setState(() {
        this.mySmartDevices = value;
      });
    });
  }

  Future getDevicesStatus() async {
    for (int i = 0; i < mySmartDevices.length; i++) {
      final DeviceValue =
          FirebaseDatabase.instance.ref().child(mySmartDevices[i][0]);
      await DeviceValue.child('status').once().then((value) {
        mySmartDevices[i][2] = value.snapshot.value;
      });
    }
    return mySmartDevices;
  }

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
      final DeviceValue =
          FirebaseDatabase.instance.ref().child(mySmartDevices[index][0]);
      DeviceValue.ref.child('status').set(value);
      DeviceValue.ref.child('status').once().then((value) => {
            print(mySmartDevices[index][0] +
                " Status: " +
                value.snapshot.value.toString())
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
                  ),
                  Text(
                    "AHMED MADANI",
                    style: GoogleFonts.bebasNeue(fontSize: 62),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                color: Colors.grey[200],
                thickness: 1,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey.shade800),
              ),
            ),
            Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.all(25),
                    itemCount: mySmartDevices.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1 / 1.3),
                    itemBuilder: (context, index) {
                      return SmartDeviceBox(
                          smartDeviceName: mySmartDevices[index][0],
                          iconPath: mySmartDevices[index][1],
                          powerOn: mySmartDevices[index][2],
                          onChanged: (value) =>
                              powerSwitchChanged(value, index));
                    }))
          ]),
        ));
  }
}
