import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

late User loggedIn;
final _auth = FirebaseAuth.instance;

class PageHeader extends StatefulWidget {
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
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedIn = user;
      }
    } catch (e) {
      // const Text('Error occured, reload the app!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.requireUserDetails)
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      loggedIn.displayName ?? loggedIn.email!,
                      style: GoogleFonts.josefinSans(
                        textStyle: TextStyle(
                            color: Colors.teal.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(loggedIn.photoURL ??
                    "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=826&t=st=1659595648~exp=1659596248~hmac=fb9c6aa3fc01d50840555a50d31a1b099a8469c24b0c01eb1326d1ff8503b8a8"),
                backgroundColor: Colors.black12,
              ),
            ],
          ),
        Text(
          widget.title,
          style: GoogleFonts.montserrat(
            textStyle:
                const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        if (widget.requireSearchBar)
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
