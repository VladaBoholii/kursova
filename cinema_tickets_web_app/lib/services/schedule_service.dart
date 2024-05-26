import 'package:cinema_tickets_web_app/models/Movie.dart';
import 'package:cinema_tickets_web_app/models/Showtime.dart';
import 'package:cinema_tickets_web_app/services/movie_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ScheduleService {
  final db = FirebaseFirestore.instance.collection("cinema_schedule");

  Future<List<Movie>?> getSchedule(String day) async {
    List<Movie> schedule = [];
    try {
      DocumentSnapshot snapshot = await db.doc("showtimes").get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> daySchedule = data[day] as Map<String, dynamic>;

      for (var entry in daySchedule.entries) {
        Map<String, dynamic> movies = entry.value;

        Map<String, dynamic> movieInfo =
            await MovieService(id: entry.key).getMovie();
        List<Showtime> showtimes = [];

        for (var timeEntry in movies.entries) {
          String key = timeEntry.key;
          dynamic time = timeEntry.value;
          Showtime showtime = Showtime.fromJson(key, time);
          showtimes.add(showtime);
        }
        Movie movie = Movie.fromJson(movieInfo, showtimes, entry.key);
        schedule.add(movie);
      }
      schedule.sort((a, b) => a.titleUA.compareTo(b.titleUA));
      return schedule;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
    return null;
  }

  Future<void> reserveSeats(
    String time,
    List<int> seatsToReserve,
    int day,
    String movieId,
  ) async {
    try {
      var ref = FirebaseFirestore.instance;
      DocumentReference docRef =
          ref.collection('cinema_schedule').doc('showtimes');
      docRef.update(
        {'$day.$movieId.$time.seats_taken': seatsToReserve},
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }
}
