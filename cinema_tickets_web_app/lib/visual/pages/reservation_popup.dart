import 'dart:ui';

import 'package:cinema_tickets_web_app/services/schedule_service.dart';
import 'package:cinema_tickets_web_app/visual/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:cinema_tickets_web_app/models/Movie.dart';
import 'package:cinema_tickets_web_app/models/Showtime.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TakeSeatPopup extends StatefulWidget {
  //day of chosen showtime
  final int day;

  //chosen showtime
  final Showtime time;

  //the movie of chosen showtime
  final Movie movie;

  const TakeSeatPopup(
      {super.key, required this.time, required this.movie, required this.day});

  @override
  State<TakeSeatPopup> createState() => _TakeSeatPopupState();
}

class _TakeSeatPopupState extends State<TakeSeatPopup> {
  //default weight and color properties for chosen seats text
  Color defaultColor = Colors.black;
  FontWeight defaultWeight = FontWeight.w400;

  //list of unavailable seats
  List<int> unavailable = [];

  //list of chosen seats
  List<int> chosenSeats = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      //get unavailable seats by getting taken seats of chosen showtime
      unavailable = List.from(widget.time.seatsTaken);
    });
  }

  void toggleChosenSeat(int seat) {
    //set default properties if user choose seat
    defaultColor = Colors.black;
    defaultWeight = FontWeight.w400;
    //remove seat from list if it is in list already
    if (chosenSeats.contains(seat)) {
      chosenSeats.remove(seat);
      //add seats to list if it is not in list yet
    } else {
      chosenSeats.add(seat);
    }
    chosenSeats.sort((a, b) => a.compareTo(b));
    setState(() {});
  }

//add chosen seats to taken setas array in database
  void reserveSeats() async {
    await ScheduleService().reserveSeats(widget.time.time,
        chosenSeats + unavailable, widget.day, widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    //main popup
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Dialog(
        //popup container
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          width: 600,
          child: Column(
            children: [
              //top decoration
              Container(
                width: 600,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepOrange[300]!, Colors.white],
                  ),
                ),
                child:

                    //titleUA at the top
                    Center(
                  child: Text(
                    widget.movie.titleUA,
                    style: GoogleFonts.philosopher(
                      // shadows: [
                      //   const Shadow(color: Colors.black87, offset: Offset(4, 4)),
                      // ],
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              //showtime info
              Center(
                child: Column(
                  children: [
                    //showtime date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //showtime day
                        Text(
                            '${DateFormat.MMMMd('uk').format(DateTime.now().add(Duration(days: widget.day)))}, ',
                            style: GoogleFonts.philosopher(
                                fontSize: 16, fontWeight: FontWeight.w400)),

                        //showtime time
                        Text(widget.time.time,
                            style: GoogleFonts.philosopher(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ],
                    ),

                    //showtime price
                    Text(widget.time.price,
                        style: GoogleFonts.philosopher(
                            fontSize: 16, fontWeight: FontWeight.w400)),

                    //space
                    const SizedBox(
                      height: 10,
                    ),

                    //screen
                    Container(
                      width: 420,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
                      ),
                    ),
                    Text(
                      'ЕКРАН',
                      style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.w600),
                    ),

                    //space
                    const SizedBox(
                      height: 10,
                    ),

                    //seats grid
                    SizedBox(
                      width: 400,
                      height: 200,
                      child:

                          //grid 5x10
                          GridView.builder(
                        itemCount: 5 * 10,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          crossAxisCount: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          //seat number
                          int seat = index + 1;

                          //seat button
                          return IconButton(
                            //black if it is in unavailable list
                            color: unavailable.contains(seat)
                                ? Colors.black

                                //orange if it is chosen
                                : chosenSeats.contains(seat)
                                    ? Colors.deepOrange.shade300

                                    //gray if it is available
                                    : Colors.grey,

                            //do nothing if user want to choose unavailable seat
                            onPressed: () => unavailable.contains(seat)
                                ? {}
                                //set seat chosen or available
                                : toggleChosenSeat(seat),
                            icon:
                                //seat icon
                                const Icon(
                              Icons.rectangle_rounded,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //space
              const SizedBox(
                height: 10,
              ),

              //seats legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //black is unavailable
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 3),
                          child: Icon(
                            Icons.rectangle_rounded,
                          ),
                        ),
                        Text("- Зайняте",
                            style: GoogleFonts.philosopher(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),

                  //gray is available
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 3),
                          child: Icon(
                            Icons.rectangle_rounded,
                            color: Colors.grey,
                          ),
                        ),
                        Text("- Вільне",
                            style: GoogleFonts.philosopher(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),

                  //orange is chosen
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.rectangle_rounded,
                          color: Colors.deepOrange[300],
                        ),
                      ),
                      Text("- Обране",
                          style: GoogleFonts.philosopher(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ],
                  )
                ],
              ),

              //space
              const SizedBox(
                height: 10,
              ),

              //chosen seats list
              Text(
                  chosenSeats.isNotEmpty
                      ? 'Обрані місця: ${chosenSeats.join(', ')}'
                      : 'Обрані місця: 0',
                  style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: defaultWeight,
                      color: defaultColor)),

              //all price based on chosen seats count
              Text(
                  'До сплати: ${chosenSeats.length * int.parse(widget.time.price.replaceAll(RegExp(r'[^0-9]'), ''))}₴',
                  style: GoogleFonts.philosopher(
                      fontSize: 16, fontWeight: FontWeight.w400)),

              //space
              const SizedBox(
                height: 15,
              ),

              //button to close popup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: TextButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.grey.shade400;
                        }

                        return Colors.grey.shade200;
                      })),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Назад',
                          style: GoogleFonts.philosopher(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600)),
                    ),
                  ),

                  //space
                  const SizedBox(
                    width: 30,
                  ),

                  //button to reserve seats
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: TextButton(
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.deepOrange.shade400;
                          }

                          return Colors.deepOrange.shade300;
                        })),
                        onPressed: () async {
                          if (chosenSeats.isNotEmpty) {
                            reserveSeats();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieSchedulePage(
                                  day: widget.day,
                                ),
                              ),
                            );

                            //show user that all done
                            return showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.of(context).pop(true);
                                  });
                                  return AlertDialog(
                                    title: Center(
                                      child: Text('Готово',
                                          style: GoogleFonts.philosopher(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  Colors.deepOrange.shade300)),
                                    ),
                                  );
                                });
                          }
                          //change properties to show user he must choose a seat
                          else {
                            defaultColor = Colors.red.shade700;
                            defaultWeight = FontWeight.w600;
                            setState(() {});
                          }
                        },
                        child: Text('Зарезервувати',
                            style: GoogleFonts.philosopher(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.white))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
