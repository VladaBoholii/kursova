import 'package:cinema_tickets_web_app/visual/components/schedule_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cinema_tickets_web_app/models/Movie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinema_tickets_web_app/services/schedule_service.dart';

// ignore: must_be_immutable
class MovieSchedulePage extends StatefulWidget {
  late int day;

  MovieSchedulePage({super.key, required this.day});

  @override
  // ignore: library_private_types_in_public_api
  _MovieSchedulePageState createState() => _MovieSchedulePageState();
}

class _MovieSchedulePageState extends State<MovieSchedulePage> {
  //schedule getting service
  late ScheduleService scheduleService;

  //list of movies playing
  List<Movie> _movies = [];

  //list of day selected options
  List<bool> isSelected = [false, false, false, false];

  @override
  void initState() {
    //set selected day
    isSelected[widget.day] = true;
    super.initState();
    initializeDateFormatting();

    //init schedule service
    scheduleService = ScheduleService();

    //getting list of movies for chosen day
    _fetchMovies(widget.day);
  }

//get movies list from database using schedule service and set it s _movies
  Future<void> _fetchMovies(int day) async {
    List<Movie>? movies = await scheduleService.getSchedule('$day');
    try {
      if (movies != null) {
        setState(() {
          _movies = movies;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching movies: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> decoration = [];

    // ignore: unused_local_variable
    for (var i in Iterable.generate(25)) {
      decoration.add(
        Transform.rotate(
          angle: 90 * (3.1415926535 / 180),
          child: const Icon(
            Icons.local_movies,
            size: 80,
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            //top gradient
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepOrange[300]!, Colors.white],
                ),
              ),
            ),

            //date buttons
            Center(
              child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: ToggleButtons(
                  textStyle: GoogleFonts.philosopher(
                      fontWeight: FontWeight.w600, fontSize: 16),
                  borderRadius: BorderRadius.circular(20),
                  selectedBorderColor: Colors.white,
                  borderColor: Colors.white,
                  fillColor: Colors.deepOrange.shade200,
                  selectedColor: Colors.black,
                  onPressed: (int index) {
                    if (isSelected[index] != true) {
                      setState(() {
                        //set all buttons unselected
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          isSelected[buttonIndex] = false;
                        }

                        //set one chosen as selected
                        isSelected[index] = true;

                        //set new day
                        widget.day = index;

                        //get new movies list
                        _fetchMovies(widget.day);
                      });
                    }
                  },
                  isSelected: isSelected,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Сьогодні'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat.MMMMd('uk')
                          .format(DateTime.now().add(const Duration(days: 1)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat.MMMMd('uk')
                          .format(DateTime.now().add(const Duration(days: 2)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat.MMMMd('uk')
                          .format(DateTime.now().add(const Duration(days: 3)))),
                    )
                  ],
                ),
              ),
            ),
          ]),

          //schedule
          FutureBuilder(
            future: scheduleService.getSchedule('${widget.day}'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _movies = snapshot.data ?? [];

                //schedule list
                return Expanded(
                  child: Schedule(
                    day: widget.day,
                    movies: _movies,
                  ),
                );
              }

              //loading data
              else {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: LinearProgressIndicator(
                    color: Colors.deepOrange[200],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
