import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MovieService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("cinema_schedule");
  final String id;

  MovieService({required this.id});

  Future getMovie() async {
    try {
      DocumentSnapshot snapshot = await _ref.doc("movies").get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data[id];
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving movies: $e");
      }
    }
  }
}
