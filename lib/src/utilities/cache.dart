/// A generic least-recently-used cache, based on Flutter's Image Cache.
///
/// The maximum size can be adjusted using [maximumSize].
///
/// The [putIfAbsent] method is the main entry-point to the cache API. It
/// returns the previously cached value for the given key, if available;
/// if not, it calls the given callback to obtain it first. In either
/// case, the key is moved to the 'most recently used' position.
///
/// A caller can determine whether a value is already in the cache by using
/// [containsKey], which will return true if the value is tracked by the cache.
class Cache<K, V> {
  final _cache = <K, V>{};

  /// Maximum number of entries to store in the cache.
  ///
  /// Once this many entries have been cached, the least-recently-used entry is
  /// evicted when adding a new entry.
  int get maximumSize => _maximumSize;
  int _maximumSize = 1000;

  /// Changes the maximum cache size.
  ///
  /// If the new size is smaller than the current number of elements, the
  /// extraneous elements are evicted immediately. Setting this to zero and then
  /// returning it to its original value will therefore immediately clear the
  /// cache.
  set maximumSize(int value) {
    assert(value >= 0);

    if (value == maximumSize) {
      return;
    }

    _maximumSize = value;

    if (value == 0) {
      _cache.clear();
      return;
    }

    while (_cache.length > _maximumSize) {
      final key = _cache.keys.first;

      _cache.remove(key);
    }
  }

  /// The current number of cached entries.
  int get currentSize => _cache.length;

  /// Evicts all entries from the cache.
  void clear() => _cache.clear();

  /// Evicts a single entry from the cache, returning true if successful.
  bool evict(K key) => _cache.remove(key) != null;

  /// Returns whether this `key` has been previously added by [putIfAbsent].
  bool containsKey(K key) => _cache.containsKey(key);

  /// Returns the previously cached value for the given key, if available;
  /// if not, calls the given callback to obtain it first. In either case, the
  /// key is moved to the 'most recently used' position.
  Future<V> putIfAbsent(K key, Future<V> Function() ifAbsent) async {
    var value = _cache.remove(key);

    if (value != null) {
      _cache[key] = value;
      return value;
    }

    try {
      value = await ifAbsent();
    } catch (_) {
      rethrow;
    }

    // Remove the oldest entries if the cache is full.
    while (_cache.length >= _maximumSize) {
      final outdated = _cache.keys.first;

      _cache.remove(outdated);
    }

    _cache[key] = value!;

    return value;
  }
}
