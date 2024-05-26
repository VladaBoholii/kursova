import 'package:cinema_tickets_web_app/models/Movie.dart';
import 'package:cinema_tickets_web_app/visual/components/movie_info.dart';
import 'package:cinema_tickets_web_app/visual/components/null.dart';
import 'package:cinema_tickets_web_app/visual/pages/reservation_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleTile extends StatefulWidget {
  //showtimes day
  final int day;

  //movie from schedule movies list
  final Movie movie;

  // ignore: use_key_in_widget_constructors
  const ScheduleTile({required this.movie, required this.day});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleTileState createState() => _ScheduleTileState();
}

class _ScheduleTileState extends State<ScheduleTile> {
  @override
  Widget build(BuildContext context) {
    //sort times
    widget.movie.showtimes.sort((a, b) {
      List<String> hour = a.time.split(':');
      List<String> min = b.time.split(':');

      int aHours = int.parse(hour[0]);
      int aMinutes = int.parse(hour[1]);
      int bHours = int.parse(min[0]);
      int bMinutes = int.parse(min[1]);

      if (aHours != bHours) {
        return aHours.compareTo(bHours);
      } else {
        return aMinutes.compareTo(bMinutes);
      }
    });

    //list of buttons to choose time
    List<Widget> showtimeButtons = [];

    //make buttons for each showtime
    for (var showtime in widget.movie.showtimes) {
      showtimeButtons.add(
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 10, top: 8),
          child: Tooltip(
            message: showtime.price,
            child: TextButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => widget.day != 0 ||
                            DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    int.parse(showtime.time.split(':')[0]),
                                    int.parse(showtime.time.split(':')[0]))
                                .isAfter(DateTime.now())
                        ? TakeSeatPopup(
                            day: widget.day,
                            movie: widget.movie,
                            time: showtime,
                          )
                        : const NullWidget());
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade300),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    //set time button orange background on hover
                    if ((states.contains(MaterialState.hovered) &&
                            DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    int.parse(showtime.time.split(':')[0]),
                                    int.parse(showtime.time.split(':')[0]))
                                .isAfter(DateTime.now()) ||
                        widget.day != 0)) {
                      return Colors.deepOrange.shade200;
                    }
                    return Colors.grey.shade300;
                  },
                ),
              ),
              child: Text(
                showtime.time,
                style:
                    GoogleFonts.philosopher(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        //poster
        Stack(alignment: Alignment.topRight, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.movie.poster,
              fit: BoxFit.cover,
              height: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(50), // Увеличиваем радиус скругления
                color: widget.movie.ageRating == '0+'
                    ? Colors.white
                    : widget.movie.ageRating == '6+'
                        ? Colors.green.shade400
                        : widget.movie.ageRating == '13+'
                            ? Colors.amber.shade300
                            : widget.movie.ageRating == '16+'
                                ? Colors.amber.shade700
                                : Colors.red.shade400,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.movie.ageRating,
                  style: GoogleFonts.philosopher(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ]),

        //movie info: rating, genres, titles, overview, tagline, runtime
        Expanded(
            child: MovieInfo(
          movie: widget.movie,
          showtimeButtons: showtimeButtons,
        )),
      ],
    );
  }
}
