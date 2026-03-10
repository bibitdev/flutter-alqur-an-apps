import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/screens/search_screen.dart';
import 'package:flutter_alquran/tabs/surah_tab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: _appbar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _greetings(context),
            ),
          ],
          body: const SurahTab(),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svgs/menu-icon.svg'),
      ),
      title: Text(
        'Al-Qur\u0027an',
        style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w500),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
          ),
        )
      ],
    );
  }

  Column _greetings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assalamualaikum',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            color: text,
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          'Bibit Raikhan A',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 24.0,
        ),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 131,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    colors: [
                      Color(0xFFDF98FA),
                      Color(0xFFB070FD),
                      Color(0xFF9055FF)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0,
                      0.6,
                      1,
                    ]),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SvgPicture.asset('assets/svgs/quran.svg'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/svgs/book.svg'),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Last Read',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Al-Fatihah',
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'Ayat No: 1',
                    style: GoogleFonts.poppins(
                      color: white,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
