import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/dzikir.dart' as DzikirModel;
import 'package:flutter_alquran/screens/detail_dzikir_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DzikirTab extends StatelessWidget {
  const DzikirTab({super.key});

  Future<List<DzikirModel.Dzikir>> _getDzikirList() async {
    try {
      String data = await rootBundle.loadString('assets/datas/dzikir-data.json');
      List<dynamic> jsonData = jsonDecode(data);
      return jsonData.map((json) => DzikirModel.Dzikir.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat data dzikir: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DzikirModel.Dzikir>>(
        future: _getDzikirList(),
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
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: white, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data dzikir',
                style: GoogleFonts.poppins(color: white),
              ),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) => _dzikirItem(
                  context: context, dzikir: snapshot.data!.elementAt(index)),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: snapshot.data!.length);
        }));
  }

  Widget _dzikirItem({required DzikirModel.Dzikir dzikir, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailDzikirScreen(
                    dzikir: dzikir,
                  )));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
