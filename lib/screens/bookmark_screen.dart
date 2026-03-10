import 'package:flutter/material.dart';
import 'package:flutter_alquran/constant.dart';
import 'package:flutter_alquran/models/bookmark.dart';
import 'package:flutter_alquran/screens/detail_screen.dart';
import 'package:flutter_alquran/services/bookmark_service.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  BookmarkScreenState createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  List<Bookmark> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final bookmarks = await BookmarkService.getBookmarks();
    // Sort by most recent first
    bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (mounted) {
      setState(() {
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(Bookmark bookmark, int index) async {
    await BookmarkService.removeBookmark(bookmark.key);
    setState(() {
      _bookmarks.removeAt(index);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bookmark ${bookmark.surahNamaLatin} ayat ${bookmark.ayatNomor} dihapus',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.grey[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: orange,
          onPressed: () async {
            await BookmarkService.addBookmark(bookmark);
            loadBookmarks();
          },
        ),
      ),
    );
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
          'Bookmark',
          style: GoogleFonts.poppins(color: white, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_bookmarks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () => loadBookmarks(),
                icon: Icon(Icons.refresh, color: white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primary))
          : _bookmarks.isEmpty
              ? _buildEmptyState()
              : _buildBookmarkList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                color: primary,
                size: 52,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Bookmark',
              style: GoogleFonts.poppins(
                color: white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ayat yang kamu simpan akan\nmuncul di sini',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: text,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkList() {
    return RefreshIndicator(
      onRefresh: loadBookmarks,
      color: primary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _bookmarks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final bookmark = _bookmarks[index];
          return Dismissible(
            key: Key(bookmark.key),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 28,
              ),
            ),
            onDismissed: (direction) => _removeBookmark(bookmark, index),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(noSurah: bookmark.surahNomor),
                ));
                // Reload bookmarks when returning from detail screen
                loadBookmarks();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${bookmark.surahNomor}',
                          style: GoogleFonts.poppins(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookmark.surahNamaLatin,
                            style: GoogleFonts.poppins(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ayat ${bookmark.ayatNomor}',
                            style: GoogleFonts.poppins(
                              color: text,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bookmark.surahNama,
                          style: GoogleFonts.amiri(
                            color: primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          Icons.bookmark,
                          color: orange,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
