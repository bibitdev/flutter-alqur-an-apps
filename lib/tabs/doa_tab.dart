import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class Doa extends StatelessWidget {
  const Doa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Text('Doa',
            style: GoogleFonts.poppins(
              color: white,
            )),
      ),
    );
  }
}
