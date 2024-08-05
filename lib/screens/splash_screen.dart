import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Al-Qur\u0027an App',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Learn Al-Qur\u0027an and\nRecite once everyday',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Stack(
                    clipBehavior: Clip.none, // Pastikan klip diatur ke none
                    children: [
                      Container(
                        width: double.infinity,
                        height: 450,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primary,
                        ),
                        child: SvgPicture.asset('assets/svgs/splash.svg'),
                      ),
                      Positioned(
                        bottom: -21, // Ubah nilai ini sesuai kebutuhan
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Get Started',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  color: grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
