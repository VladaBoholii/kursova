import 'package:cinema_tickets_web_app/models/Movie.dart';
import 'package:cinema_tickets_web_app/visual/components/schedule_tile.dart';
import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  //schedule day
  final int day;

  //schedule playing movies
  final List<Movie> movies;
  const Schedule({super.key, required this.movies, required this.day});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        Movie movie = movies[index];
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ScheduleTile(
            movie: movie,
            day: day,
          ),
        );
      },
    );
  }
}
