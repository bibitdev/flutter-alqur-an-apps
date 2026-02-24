import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class JadwalSholatScreen extends StatefulWidget {
  const JadwalSholatScreen({super.key});

  @override
  State<JadwalSholatScreen> createState() => _JadwalSholatScreenState();
}

class _JadwalSholatScreenState extends State<JadwalSholatScreen> {
  Map<String, dynamic>? _timings;
  bool _isLoading = true;
  String? _error;
  String _city = 'Jakarta';
  String _country = 'Indonesia';

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final now = DateTime.now();
      final dateStr = DateFormat('dd-MM-yyyy').format(now);
      var response = await Dio().get(
        'https://api.aladhan.com/v1/timingsByCity/$dateStr',
        queryParameters: {
          'city': _city,
          'country': _country,
          'method': 20, // Method 20 = Kemenag Indonesia
        },
      );
      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      setState(() {
        _timings = data['data']['timings'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat jadwal sholat: $e';
        _isLoading = false;
      });
    }
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
          'Jadwal Sholat',
          style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: _fetchPrayerTimes,
            icon: Icon(Icons.refresh, color: white),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: primary),
            )
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: orange, size: 56),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.poppins(color: white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchPrayerTimes,
              icon: const Icon(Icons.refresh),
              label: Text('Coba Lagi',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

    final prayerTimes = [
      _PrayerTime('Imsak', _timings?['Imsak'] ?? '-', Icons.nightlight_round),
      _PrayerTime('Subuh', _timings?['Fajr'] ?? '-', Icons.wb_twilight),
      _PrayerTime(
          'Terbit', _timings?['Sunrise'] ?? '-', Icons.wb_sunny_outlined),
      _PrayerTime('Dzuhur', _timings?['Dhuhr'] ?? '-', Icons.wb_sunny),
      _PrayerTime('Ashar', _timings?['Asr'] ?? '-', Icons.sunny_snowing),
      _PrayerTime('Maghrib', _timings?['Maghrib'] ?? '-', Icons.wb_twilight),
      _PrayerTime('Isya', _timings?['Isha'] ?? '-', Icons.nights_stay),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFDF98FA),
                  Color(0xFFB070FD),
                  Color(0xFF9055FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.mosque_rounded, color: white, size: 48),
                const SizedBox(height: 12),
                Text(
                  _city,
                  style: GoogleFonts.poppins(
                    color: white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _country,
                  style: GoogleFonts.poppins(
                    color: white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    dateFormatted,
                    style: GoogleFonts.poppins(
                      color: white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Prayer times list
          ...prayerTimes.map((prayer) => _buildPrayerCard(prayer)),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(_PrayerTime prayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              prayer.icon,
              color: primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              prayer.name,
              style: GoogleFonts.poppins(
                color: white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            prayer.time,
            style: GoogleFonts.poppins(
              color: orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerTime {
  final String name;
  final String time;
  final IconData icon;

  _PrayerTime(this.name, this.time, this.icon);
}
