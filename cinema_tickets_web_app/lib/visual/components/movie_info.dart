import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinema_tickets_web_app/models/Movie.dart';

// ignore: must_be_immutable
class MovieInfo extends StatefulWidget {
  Movie movie;
  List<Widget> showtimeButtons;

  MovieInfo({
    super.key,
    required this.movie,
    required this.showtimeButtons,
  });

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  @override
  Widget build(BuildContext context) {
// Calculate hours and minutes
    int hours = widget.movie.runtime ~/ 60;
    int minutes = widget.movie.runtime % 60;

    return ListTile(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title UA
          Text(
            widget.movie.titleUA,
            style: GoogleFonts.philosopher(fontSize: 26),
          ),

          //title original
          Text(
            widget.movie.titleOriginal,
            style: GoogleFonts.philosopher(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //showtimes buttons
          Row(
            children: [
              Row(
                children: widget.showtimeButtons,
              ),
              Text(
                ' $hoursг $minutesхв',
                style: GoogleFonts.philosopher(
                  fontSize: 14,
                ),
              ),
            ],
          ),

          //tagline
          Text(
            widget.movie.tagline,
            textAlign: TextAlign.justify,
            style: GoogleFonts.philosopher(
                fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
          ),

          //genres
          Text(
            widget.movie.genres.join(', '),
            style: GoogleFonts.philosopher(fontSize: 16, color: Colors.black),
          ),

          //overview
          Text(
            widget.movie.overview,
            textAlign: TextAlign.justify,
            style: GoogleFonts.philosopher(fontSize: 17, color: Colors.black),
          )
        ],
      ),
    );
  }
}
