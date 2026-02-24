import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/doa.dart' as DoaModel;
import 'package:flutter_alquran/screens/detail_doa_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DoaTab extends StatelessWidget {
  const DoaTab({super.key});

  Future<List<DoaModel.Doa>> _getDoaList() async {
    try {
      var response = await Dio().get('https://equran.id/api/doa');
      var responseData = response.data;
      
      // Handle if response is a List or if it's wrapped in an object
      List<dynamic> data;
      if (responseData is List) {
        data = responseData;
      } else if (responseData is Map && responseData.containsKey('data')) {
        data = responseData['data'];
      } else {
        // If the response is a Map, convert its values to a list
        data = (responseData as Map).values.toList();
      }
      
      return data.map((json) => DoaModel.Doa.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat data doa: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoaModel.Doa>>(
        future: _getDoaList(),
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
                'Tidak ada data doa',
                style: GoogleFonts.poppins(color: white),
              ),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) => _doaItem(
                  context: context, doa: snapshot.data!.elementAt(index)),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: snapshot.data!.length);
        }));
  }

  Widget _doaItem({required DoaModel.Doa doa, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailDoaScreen(
                    doa: doa,
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
}
