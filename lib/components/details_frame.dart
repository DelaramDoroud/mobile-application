import 'package:flutter/material.dart';

class DetailsFrame extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final Color color;
  const DetailsFrame({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.35,
        //height: MediaQuery.of(context).size.height * 0.8,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 92.0,
              width: 200,
              fit: BoxFit.cover,
              image: AssetImage(imagePath),
            ),
            SizedBox(height: 7.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 7.0),
            Text(price),

            //Text("1 - 6 Apr"),
          ],
        ),
        //Image.asset("images/pic1.png"),
      ),
    );
  }
}
