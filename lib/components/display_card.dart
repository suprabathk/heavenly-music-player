import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayCard extends StatelessWidget {
  const DisplayCard({
    Key? key,
    required this.cardImage,
    required this.cardTitle,
    required this.cardSubTitle,
  }) : super(key: key);

  final String cardImage;
  final String cardTitle;
  final String cardSubTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          image:
              DecorationImage(image: NetworkImage(cardImage), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardTitle,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              cardSubTitle,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
