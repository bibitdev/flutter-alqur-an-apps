import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/tabs/doa_tab.dart';
import 'package:flutter_alquran/tabs/dzikir_tab.dart';
import 'package:flutter_alquran/screens/tafsir.dart';
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
      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _greetings(context),
              ),
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: background,
                automaticallyImplyLeading: false,
                shape: Border(
                    bottom: BorderSide(
                        width: 3,
                        color: const Color(0xFFAAAAAA).withOpacity(.1))),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: TabBar(
                      unselectedLabelColor: text,
                      labelColor: Colors.white,
                      indicatorColor: primary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        _tabItem(label: 'Surah'),
                        _tabItem(label: 'Tafsir'),
                        _tabItem(label: 'Do\u0027a'),
                        _tabItem(label: 'Dzikir'),
                      ]),
                ),
              )
            ],
            body: const TabBarView(
              children: [
                SurahTab(),
                Tafsir(),
                Doa(),
                Dzikir(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomnavbar(),
    );
  }

  Tab _tabItem({required String label}) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
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
        style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w500),
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
    );
  }

  BottomNavigationBar _bottomnavbar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (value) {},
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/quran-icon.svg'),
          label: 'Surah',
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/lamp-icon.svg'), label: 'Tips'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/pray-icon.svg'),
            label: 'Sholat'),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/doa-icon.svg'),
          label: 'Doa',
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/bookmark-icon.svg'),
            label: 'Bookmark'),
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
      ],
    );
  }
}
