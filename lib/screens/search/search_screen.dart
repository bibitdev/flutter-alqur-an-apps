import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/surah.dart';
import 'package:flutter_alquran/screens/detail_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    String data = await rootBundle.loadString('assets/datas/list-surah.json');
    setState(() {
      _allSurahs = surahFromJson(data);
      _filteredSurahs = [];
      _isLoading = false;
    });
  }

  void _filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSurahs = [];
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredSurahs = _allSurahs.where((surah) {
        return surah.namaLatin.toLowerCase().contains(lowerQuery) ||
            surah.nama.contains(query) ||
            surah.arti.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/back-icon.svg'),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _filterSurahs,
          style: GoogleFonts.poppins(color: white, fontSize: 16),
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: 'Cari surah...',
            hintStyle: GoogleFonts.poppins(color: text, fontSize: 16),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                _filterSurahs('');
              },
              icon: Icon(Icons.close, color: text),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: primary),
      );
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: text, size: 64),
            const SizedBox(height: 16),
            Text(
              'Ketik nama surah untuk mencari...',
              style: GoogleFonts.poppins(color: text, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_filteredSurahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: text, size: 64),
            const SizedBox(height: 16),
            Text(
              'Surah tidak ditemukan',
              style: GoogleFonts.poppins(color: text, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredSurahs.length,
      separatorBuilder: (context, index) =>
          Divider(color: const Color(0xFF7B80AD).withOpacity(.35)),
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        return _surahItem(context: context, surah: surah);
      },
    );
  }

  Widget _surahItem({required Surah surah, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailScreen(noSurah: surah.nomor)));
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
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          surah.tempatTurun.name,
                          style: GoogleFonts.poppins(
                              color: text,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: text),
                        ),
                        const SizedBox(width: 5),
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
