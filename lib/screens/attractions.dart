import 'package:flutter/material.dart';
import 'package:tourism_app/data/firestore_repo.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/screens/reservation.dart';

class Attractions extends StatefulWidget {
  const Attractions({super.key});

  @override
  State<Attractions> createState() => _AttractionsState();
}

class _AttractionsState extends State<Attractions> {
  final FirestoreRepo _repo = FirestoreRepo();
  late final Stream<List<Attraction>> _attractions$;

  void initState() {
    super.initState();
    _attractions$ = _repo.streamAttractions().map(
      (list) =>
          list.map((m) => Attraction.fromMap(m['id'] as String, m)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tourist Attractions")),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: GenericGridView<Attraction>(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
              stream: _attractions$,
              itemBuilder: (a) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/pic12.jpg',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // a.images.isNotEmpty
                      //     ? Image.network(
                      //       a.images[0],
                      //       height: 120,
                      //       width: double.infinity,
                      //       fit: BoxFit.cover,
                      //     )
                      // : Container(
                      //   height: 120,
                      //   color: Colors.grey,
                      //   child: Center(child: Text('No Image')),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          a.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          a.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          a.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
