import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Bookmark',
          style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: primary,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Belum Ada Bookmark',
                style: GoogleFonts.poppins(
                  color: white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ayat yang kamu simpan akan\nmuncul di sini',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: text,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
