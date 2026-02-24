import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/screens/home_screen.dart';
import 'package:flutter_alquran/screens/tafsir.dart';
import 'package:flutter_alquran/screens/doa_dzikir_screen.dart';
import 'package:flutter_alquran/screens/jadwal_sholat_screen.dart';
import 'package:flutter_alquran/screens/bookmark_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    Tafsir(),
    DoaDzikirScreen(),
    JadwalSholatScreen(),
    BookmarkScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: grey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: grey,
          selectedItemColor: primary,
          unselectedItemColor: text,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  'assets/svgs/quran-icon.svg',
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 0 ? primary : text,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: "Al-Qur'an",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: _currentIndex == 1 ? primary : text,
                ),
              ),
              label: 'Tafsir',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  'assets/svgs/doa-icon.svg',
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 2 ? primary : text,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: "Do'a & Dzikir",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  'assets/svgs/pray-icon.svg',
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 3 ? primary : text,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: 'Sholat',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  'assets/svgs/bookmark-icon.svg',
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 4 ? primary : text,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              label: 'Bookmark',
            ),
          ],
        ),
      ),
    );
  }
}
