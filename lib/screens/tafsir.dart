import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/surah.dart';
import 'package:flutter_alquran/screens/detail_tafsir_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Tafsir extends StatelessWidget {
  const Tafsir({super.key});

  Future<List<Surah>> _getSurahList() async {
    String data = await rootBundle.loadString('assets/datas/list-surah.json');
    return surahFromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Tafsir Al-Qur\u0027an',
          style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w600),
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
      body: FutureBuilder<List<Surah>>(
          future: _getSurahList(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada data tafsir',
                  style: GoogleFonts.poppins(color: white),
                ),
              );
            }
            return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) => _tafsirItem(
                    context: context, surah: snapshot.data!.elementAt(index)),
                separatorBuilder: (context, index) =>
                    Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
                itemCount: snapshot.data!.length);
          })),
    );
  }

  Widget _tafsirItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailTafsirScreen(
                    noSurah: surah.nomor,
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset('assets/svgs/nomor-surah.svg'),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                        child: Text(
                      "${surah.nomor}",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    )),
                  )
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          surah.tempatTurun.name,
                          style: GoogleFonts.poppins(
                              color: text,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: text),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${surah.jumlahAyat} Ayat",
                          style: GoogleFonts.poppins(
                              color: text,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                surah.nama,
                style: GoogleFonts.amiri(
                    color: primary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
