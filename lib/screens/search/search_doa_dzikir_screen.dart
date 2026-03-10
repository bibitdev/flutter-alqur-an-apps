import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/doa.dart' as DoaModel;
import 'package:flutter_alquran/models/dzikir.dart' as DzikirModel;
import 'package:flutter_alquran/screens/detail_doa_screen.dart';
import 'package:flutter_alquran/screens/detail_dzikir_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchDoaDzikirScreen extends StatefulWidget {
  const SearchDoaDzikirScreen({super.key});

  @override
  State<SearchDoaDzikirScreen> createState() => _SearchDoaDzikirScreenState();
}

class _SearchDoaDzikirScreenState extends State<SearchDoaDzikirScreen> {
  List<DoaModel.Doa> _allDoa = [];
  List<DzikirModel.Dzikir> _allDzikir = [];
  List<DoaModel.Doa> _filteredDoa = [];
  List<DzikirModel.Dzikir> _filteredDzikir = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load doa from API
      final doaFuture = _loadDoa();
      // Load dzikir from local JSON
      final dzikirFuture = _loadDzikir();

      await Future.wait([doaFuture, dzikirFuture]);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  Future<void> _loadDoa() async {
    try {
      var response = await Dio().get('https://equran.id/api/doa');
      var responseData = response.data;

      List<dynamic> data;
      if (responseData is List) {
        data = responseData;
      } else if (responseData is Map && responseData.containsKey('data')) {
        data = responseData['data'];
      } else {
        data = (responseData as Map).values.toList();
      }

      _allDoa = data.map((json) => DoaModel.Doa.fromJson(json)).toList();
    } catch (e) {
      _allDoa = [];
    }
  }

  Future<void> _loadDzikir() async {
    try {
      String data =
          await rootBundle.loadString('assets/datas/dzikir-data.json');
      List<dynamic> jsonData = jsonDecode(data);
      _allDzikir =
          jsonData.map((json) => DzikirModel.Dzikir.fromJson(json)).toList();
    } catch (e) {
      _allDzikir = [];
    }
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredDoa = [];
        _filteredDzikir = [];
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredDoa = _allDoa.where((doa) {
        return doa.nama.toLowerCase().contains(lowerQuery) ||
            doa.tentang.toLowerCase().contains(lowerQuery);
      }).toList();

      _filteredDzikir = _allDzikir.where((dzikir) {
        return dzikir.nama.toLowerCase().contains(lowerQuery) ||
            dzikir.tentang.toLowerCase().contains(lowerQuery);
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
          onChanged: _filterData,
          style: GoogleFonts.poppins(color: white, fontSize: 16),
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: "Cari do'a atau dzikir...",
            hintStyle: GoogleFonts.poppins(color: text, fontSize: 16),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                _filterData('');
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

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: text, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(color: text, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
              "Ketik untuk mencari do'a atau dzikir...",
              style: GoogleFonts.poppins(color: text, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_filteredDoa.isEmpty && _filteredDzikir.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: text, size: 64),
            const SizedBox(height: 16),
            Text(
              "Do'a atau dzikir tidak ditemukan",
              style: GoogleFonts.poppins(color: text, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Doa results
        if (_filteredDoa.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Do'a (${_filteredDoa.length})",
              style: GoogleFonts.poppins(
                color: primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._filteredDoa.map((doa) => _doaItem(context: context, doa: doa)),
        ],
        // Dzikir results
        if (_filteredDzikir.isNotEmpty) ...[
          if (_filteredDoa.isNotEmpty) const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Dzikir (${_filteredDzikir.length})',
              style: GoogleFonts.poppins(
                color: primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._filteredDzikir
              .map((dzikir) => _dzikirItem(context: context, dzikir: dzikir)),
        ],
      ],
    );
  }

  Widget _doaItem({required DoaModel.Doa doa, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailDoaScreen(doa: doa)));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_book,
                    color: white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doa.nama,
                      style: GoogleFonts.poppins(
                        color: white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doa.tentang,
                      style: GoogleFonts.poppins(
                        color: text,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: primary,
              ),
            ],
          ),
        ),
      );

  Widget _dzikirItem(
          {required DzikirModel.Dzikir dzikir,
          required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailDzikirScreen(dzikir: dzikir)));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_stories,
                    color: white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dzikir.nama,
                      style: GoogleFonts.poppins(
                        color: white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dzikir.tentang,
                      style: GoogleFonts.poppins(
                        color: text,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (dzikir.jumlah != null && dzikir.jumlah!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.repeat,
                              color: orange,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Dibaca ${dzikir.jumlah}x',
                              style: GoogleFonts.poppins(
                                color: orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: primary,
              ),
            ],
          ),
        ),
      );
}
