// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter_application_1/controller/profiledata.dart';  
import 'package:flutter_application_1/controller/scheduledata.dart'; 
import 'package:flutter_application_1/controller/tutordata.dart';     
import 'package:flutter_application_1/model/global.dart';            
import 'package:flutter_application_1/model/profile.dart';          
import 'package:flutter_application_1/model/schedule.dart';         
import 'package:flutter_application_1/model/user.dart';             
import 'package:flutter_application_1/view/home/loading.dart';     
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BrowseDetails extends StatefulWidget {
  final String idTutor;
  final String subject;

  BrowseDetails({Key? key, required this.idTutor, required this.subject}) : super(key: key);

  @override
  _BrowseDetailsState createState() => _BrowseDetailsState();
}

class _BrowseDetailsState extends State<BrowseDetails> with TickerProviderStateMixin {
  TabController? _tabController; 
  String day = DateFormat.E().format(DateTime.now());
  int date = DateTime.now().day;
  DateTime _bookDate = DateTime.now(); // Ensure this is declared properly

  // final TextStyle _label = TextStyle(
  //   color: Colors.black,
  //   fontSize: 14,
  // );

  // booking variables
// Assuming you have access to user.id or some other id
final TutorDataService _session = TutorDataService(id: 'id'); // Pass the required id
  final _formKey = GlobalKey<FormState>();
  String? sb; // Made nullable to avoid initialization issues
  int? sl; // Made nullable
  String? vn; // Made nullable
  String? dt; // Made nullable
  String? dy; // Made nullable

  final snackBar = SnackBar(content: Text('Booking request sent!'));

  List<String?> _scheduleDay = List.filled(7, null); // Initialized properly
  String harini = 'Today';

  TextStyle info = TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  TextStyle title = TextStyle(
    fontSize: 15,
    color: Colors.black54,
    height: 1.5,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Feather.chevron_left,
              color: bl,
              size: 35,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: yl,
          bottom: TabBar(
            labelColor: bl,
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Feather.user)),
              Tab(icon: Icon(Feather.calendar)),
              Tab(icon: Icon(Feather.book_open)),
            ],
            indicatorColor: Colors.black,
          ),
          flexibleSpace: StreamBuilder<Profile>(
              stream: ProfileDataService(uid: widget.idTutor).profile,
              builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No profile data found.'));
                }
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  color: yl,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 190,
                        width: double.infinity,
                      ),
                      Positioned(
                        right: 13,
                        child: Container(
                          padding: EdgeInsets.only(left: 58),
                          height: 150,
                          width: 270,
                          decoration: BoxDecoration(
                            color: wy,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data!.fullName,
                                style: TextStyle(fontSize: 23),
                              ),
                              Text(
                                snapshot.data!.bio,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 48,
                        left: 10,
                        child: ClipOval(
                          child: SizedBox(
                            height: 130.0,
                            width: 130.0,
                            child: Image.network(
                              snapshot.data!.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),
        ),
        preferredSize: Size.fromHeight(200.0),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // profile
          StreamBuilder<Profile>(
              stream: ProfileDataService(uid: widget.idTutor).profile,
              builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No profile data found.'));
                }
                return Container(
                  color: wy,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'Phone Number',
                                style: title,
                              ),
                              subtitle: Text(
                                snapshot.data!.phoneNumber,
                                style: info,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Bio',
                                style: title,
                              ),
                              subtitle: Text(
                                snapshot.data!.bio,
                                style: info,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Address',
                                style: title,
                              ),
                              subtitle: Text(
                                snapshot.data!.address,
                                style: info,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Education',
                                style: title,
                              ),
                              subtitle: Text(
                                snapshot.data!.education,
                                style: info,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Experience',
                                style: title,
                              ),
                              subtitle: Text(
                                snapshot.data!.extraInfo,
                                style: info,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),


          //schedule
          Container(
            color: wy,
            padding: EdgeInsets.only(top: 10),
            child: StreamBuilder(
                stream: ScheduleDataService(uid: widget.idTutor).schedule,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Schedule>> snapshot) {
                  if (snapshot.hasData) {
                    List<Schedule>? scheduleData = snapshot.data;

                    return ListView.builder(
                      itemCount: scheduleData?.length,
                      itemBuilder: (context, index) {
                        switch (scheduleData?[index].id) {
                          case "mon":
                            {
                              _scheduleDay[index] = 'Monday';
                            }
                            break;

                          case "tue":
                            {
                              _scheduleDay[index] = 'Tuesday';
                            }
                            break;

                          case "wed":
                            {
                              _scheduleDay[index] = 'Wednesday';
                            }
                            break;

                          case "thu":
                            {
                              _scheduleDay[index] = 'Thursday';
                            }
                            break;
                          case "fri":
                            {
                              _scheduleDay[index] = 'Friday';
                            }
                            break;
                          case "sat":
                            {
                              _scheduleDay[index] = 'Saturday';
                            }
                            break;
                          case "sun":
                            {
                              _scheduleDay[index] = 'Sunday';
                            }
                            break;
                        }
                        return TimelineTile(
                          beforeLineStyle: LineStyle(
                            color: bl,
                            thickness: 3,
                          ),
                          afterLineStyle: LineStyle(
                            color: bl,
                            thickness: 3,
                          ),
                          //isFirst: true,
                          lineXY: 0,
                          indicatorStyle: IndicatorStyle(
                            color: scheduleData?[index].id == day.toLowerCase()
                                ? yl
                                : bl,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            width: 13,
                            indicatorXY: 0.1,
                          ),
                          alignment: TimelineAlign.start,

                          //schedule part
                          endChild: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            color: yl,
                            child: Container(
                              //margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                              padding: EdgeInsets.only(
                                  left: 20, right: 30, top: 17, bottom: 30),
                              color: scheduleData?[index].id == day.toLowerCase()
                                  ? yl
                                  : wy,
                              //
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //day
                                  SizedBox(
                                    height: 35,
                                    child: Text(
                                      _scheduleDay[index]!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  //slot1
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      color: scheduleData![index].slot1
                                          ? Colors.redAccent
                                          : Colors.greenAccent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Slot 1',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            "(8am-10am)",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //slot2
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        color: scheduleData[index].slot2
                                            ? Colors.redAccent
                                            : Colors.greenAccent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Slot 2',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              "(12pm-2pm)",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //slot3
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        color: scheduleData[index].slot3
                                            ? Colors.redAccent
                                            : Colors.greenAccent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Slot 3',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              "(4pm-5pm)",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Loading();
                  }
                }),
          ),

          //book

          Container(
              color: wy,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    //subject
                    SizedBox(height: 40.0),
                    Text('Subject', style: info),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: widget.subject,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        fillColor: bl,
                      ),
                      onChanged: (val) {
                        setState(() => sb = widget.subject);
                      },
                    ),

                    //date
                    SizedBox(height: 40.0),
                    Text('Date', style: info),
                    ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow, // Change this to your color variable 'yl'
          ),
          child: Text(
            // ignore: unnecessary_null_comparison
            _bookDate == null
                ? 'Pick Date'
                : DateFormat('yMd').format(_bookDate).toString(),
          ),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime.now(), // Allow selection until today
              cancelText: 'Cancel',
              confirmText: 'Select',
            ).then((date) {
              if (date != null) { // Check if date is not null
                setState(() {
                  _bookDate = date;
                  dt = DateFormat('yMd').format(_bookDate).toString();
                  dy = _bookDate.day.toString();
                });
              }
            });
          },
        ),
                    //FlatButton(
                    //   onPressed: null, child: Text(_bookDate.toString())),

                    //slot
                    SizedBox(height: 40.0),
                    Text('Slot', style: info),
                    DropdownButton(
                        underline: Container(
                          height: 1,
                          color: bl,
                        ),
                        hint: Text('Select Slot'),
                        value: sl,
                        items: [
                          DropdownMenuItem(
                            child: Text('Slot 1: 8am-10am'),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text('Slot 2: 12pm-2pm'),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text('Slot 3: 4pm-5pm'),
                            value: 3,
                          ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            sl = val;
                          });
                        }),

                    //venue
                    SizedBox(height: 40.0),
                    Text('Location', style: info),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tutor Venue',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        //labelStyle: _label,
                        //labelText: 'Tutor Venue',
                        fillColor: bl,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter tutor venue!' : null,
                      onChanged: (val) {
                        setState(() => vn = val);
                      },
                    ),

                    //book button
                   SizedBox(height: 50.0),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    backgroundColor: bl, // Set the button color
    padding: EdgeInsets.symmetric(vertical: 18), // Set vertical padding
  ),
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      await _session.addTutorSession(
        widget.idTutor,
        user.uid,
        widget.subject,
        dt!,
        dy!,
        sl!,
        vn!,
      );
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close, color: yl),
                    backgroundColor: bl,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Center(
                      child: Text('Booking request sent!'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  },
  child: Text(
    'Book',
    style: TextStyle(
      color: Colors.white,
      fontSize: 15.0,
      letterSpacing: 1.5,
    ),
  ),
),

                    
                  ])))
        ],
      ),
    );
  }
}
