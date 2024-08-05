import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/menu-icon.svg'),
        ),
        title: Text(
          'Al-Qur\u0027an',
          style: GoogleFonts.poppins(
              color: Color.fromARGB(217, 228, 220, 220),
              fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
            ),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Home Screens',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
