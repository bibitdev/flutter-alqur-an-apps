import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/dzikir.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailDzikirScreen extends StatelessWidget {
  const DetailDzikirScreen({super.key, required this.dzikir});

  final Dzikir dzikir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context: context),
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _headerCard(),
              const SizedBox(height: 32),
              _contentSection(
                title: 'Dzikir Arab',
                icon: Icons.auto_stories,
                child: Text(
                  dzikir.ar,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(
                    color: white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _contentSection(
                title: 'Terjemahan',
                icon: Icons.translate,
                child: Text(
                  dzikir.idn,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    color: white,
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _contentSection(
                title: 'Tentang Dzikir',
                icon: Icons.info_outline,
                child: Text(
                  dzikir.tentang,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    color: white,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
              if (dzikir.jumlah != null && dzikir.jumlah!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: orange, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.repeat,
                        color: orange,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Dibaca ${dzikir.jumlah}x',
                        style: GoogleFonts.poppins(
                          color: orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDF98FA),
            Color(0xFFB070FD),
            Color(0xFF9055FF)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.auto_stories,
              color: white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            dzikir.nama,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  AppBar _appbar({required BuildContext context}) {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/svgs/back-icon.svg'),
      ),
      title: Text(
        'Detail Dzikir',
        style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w500),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              // TODO: Implement share functionality
            },
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        )
      ],
    );
  }
}
