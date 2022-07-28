import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageHeader extends StatelessWidget {
  const PageHeader(
      {Key? key,
      required this.title,
      this.requireSearchBar = false,
      required this.requireUserDetails})
      : super(key: key);

  final String title;
  final bool requireSearchBar;
  final bool requireUserDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (requireUserDetails)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                  Text(
                    'User name',
                    style: GoogleFonts.josefinSans(
                      textStyle: TextStyle(
                          color: Colors.teal.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/clonex.png'),
                backgroundColor: Colors.black12,
              ),
            ],
          ),
        Text(
          title,
          style: GoogleFonts.montserrat(
            textStyle:
                const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        if (requireSearchBar)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusColor: Colors.black12,
                      prefixIcon:
                          const Icon(Icons.search_rounded, color: Colors.grey),
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.teal.shade700,
                child: const Icon(Icons.tune_rounded,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
      ],
    );
  }
}
