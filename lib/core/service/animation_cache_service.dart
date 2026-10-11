import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AnimationCacheService {
  AnimationCacheService._();

  static final CacheManager _cacheManager = CacheManager(
    Config(
      'exerciseAnimationCache',
      stalePeriod: const Duration(days: 3650),
      maxNrOfCacheObjects: 1000,
    ),
  );

  static Future<File> getFile(String url) async {
    return await _cacheManager.getSingleFile(url);
  }

  static Future<FileInfo?> getCachedFile(String url) async {
    return await _cacheManager.getFileFromCache(url);
  }

  static Future<void> removeFile(String url) async {
    await _cacheManager.removeFile(url);
  }

  static Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}