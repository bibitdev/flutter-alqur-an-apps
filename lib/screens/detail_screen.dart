import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/surah.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.noSurah});

  final int noSurah;
  Future<Surah> _getDetailSurah() async {
    var data = await Dio().get('https://equran.id/api/surat/$noSurah');
    print(data);
    return Surah.fromJson(jsonDecode(data.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: FutureBuilder(
            future: _getDetailSurah(),
            builder: ((context, snapshot) {
              return SafeArea(child: Text('$noSurah', style: TextStyle(color: Colors.white,),));
            })));
  }
}
