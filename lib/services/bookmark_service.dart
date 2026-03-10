import 'package:flutter_alquran/models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'bookmarks';

  /// Get all saved bookmarks
  static Future<List<Bookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null || data.isEmpty) {
      return [];
    }
    return Bookmark.listFromJson(data);
  }

  /// Add a bookmark
  static Future<void> addBookmark(Bookmark bookmark) async {
    final bookmarks = await getBookmarks();
    // Prevent duplicates
    if (bookmarks.any((b) => b.key == bookmark.key)) return;
    bookmarks.add(bookmark);
    await _save(bookmarks);
  }

  /// Remove a bookmark by its key (surahNomor_ayatNomor)
  static Future<void> removeBookmark(String bookmarkKey) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.key == bookmarkKey);
    await _save(bookmarks);
  }

  /// Check if a specific ayat is bookmarked
  static Future<bool> isBookmarked(int surahNomor, int ayatNomor) async {
    final bookmarks = await getBookmarks();
    final key = '${surahNomor}_$ayatNomor';
    return bookmarks.any((b) => b.key == key);
  }

  /// Toggle bookmark: add if not exists, remove if exists. Returns new state.
  static Future<bool> toggleBookmark(Bookmark bookmark) async {
    final bookmarks = await getBookmarks();
    final exists = bookmarks.any((b) => b.key == bookmark.key);
    if (exists) {
      bookmarks.removeWhere((b) => b.key == bookmark.key);
    } else {
      bookmarks.add(bookmark);
    }
    await _save(bookmarks);
    return !exists;
  }

  static Future<void> _save(List<Bookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Bookmark.listToJson(bookmarks));
  }
}
