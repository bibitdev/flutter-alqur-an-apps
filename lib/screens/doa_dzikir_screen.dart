import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/screens/search_doa_dzikir_screen.dart';
import 'package:flutter_alquran/tabs/doa_tab.dart';
import 'package:flutter_alquran/tabs/dzikir_tab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DoaDzikirScreen extends StatelessWidget {
  const DoaDzikirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Do'a & Dzikir",
            style:
                GoogleFonts.poppins(color: white, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchDoaDzikirScreen(),
                    ),
                  );
                },
                icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: const Color(0xFFAAAAAA).withOpacity(.1),
                  ),
                ),
              ),
              child: TabBar(
                unselectedLabelColor: text,
                labelColor: Colors.white,
                indicatorColor: primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Text(
                      "Do'a",
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Dzikir',
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            DoaTab(),
            DzikirTab(),
          ],
        ),
      ),
    );
  }
}
