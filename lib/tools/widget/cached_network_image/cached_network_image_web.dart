
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:base/tools/widget/cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:ui' as ui show instantiateImageCodec, Codec;

class CachedNetworkImageWeb extends CachedNetworkImage {

  CachedNetworkImageWeb(String url, width, height, boxFit, align) : super.protected() {
    super.url = url;
    super.width = width;
    super.height = height;
    super.boxFit = boxFit;
    super.align = align;
  }

  @override
  Widget build(BuildContext context) {
    BoxFit _boxFit = BoxFit.scaleDown;
    if (boxFit == 1) {
      _boxFit = BoxFit.fill;
    } else if (boxFit == 2) {
      _boxFit = BoxFit.contain;
    } else if (boxFit == 3) {
      _boxFit = BoxFit.cover;
    } else if (boxFit == 4) {
      _boxFit = BoxFit.fitWidth;
    } else if (boxFit == 5) {
      _boxFit = BoxFit.fitHeight;
    }
    return Image(
      image: CachedNetworkImageProvider(url),
      width: width,
      height: height,
      fit: _boxFit,
      alignment: align,
    );
  }

}

CachedNetworkImage getCachedNetworkImage(url, width, height, boxFit, align) => CachedNetworkImageWeb(url, width, height, boxFit, align);

typedef void ErrorListener();

class CachedNetworkImageProvider  extends ImageProvider<CachedNetworkImageProvider> {
  /// Creates an ImageProvider which loads an image from the [url], using the [scale].
  /// When the image fails to load [errorListener] is called.
  const CachedNetworkImageProvider(this.url, {this.scale = 1.0, this.errorListener, this.headers, this.cacheManager})
      : assert(url != null),
        assert(scale != null);

  final WebCacheManager cacheManager;

  /// Web url of the image to load
  final String url;

  /// Scale of the image
  final double scale;

  /// Listener to be called when images fails to load.
  final ErrorListener errorListener;

  // Set headers for the image provider, for example for authentication
  final Map<String, String> headers;

  @override
  Future<CachedNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedNetworkImageProvider>(this);
  }

  @override
  ImageStreamCompleter load(CachedNetworkImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>(
          'Image provider: $this \n Image key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  Future<ui.Codec> _loadAsync(CachedNetworkImageProvider key) async {
    var mngr = cacheManager ?? WebCacheManager();
    var bytes = await mngr.getFile(url, headers: headers);
    if (bytes == null) {
      if (errorListener != null) errorListener();
      throw Exception('Couldn\'t download or retrieve file: $url');
    }
    if (bytes.lengthInBytes == 0) {
      if (errorListener != null) errorListener();
      throw Exception('File was empty');
    }

    return ui.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other is CachedNetworkImageProvider) {
      return url == other.url && scale == other.scale;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}

class WebCacheManager {

  final Storage _localStorage = window.localStorage;
  static Map<String, Uint8List> _memCache = {};

  WebCacheManager();

  Future<Uint8List> getFile(String url, {Map<String, String> headers}) async {
    if (_memCache.containsKey(url)) {
      return _memCache[url];
    } else if (_localStorage.containsKey(url)) {
      return base64Decode(_localStorage[url]);
    } else {
      var httpResponse = await http.get(url, headers: headers);
      if (httpResponse.statusCode != 200) {
        return null;
      } else {
        _memCache[url] = httpResponse.bodyBytes;
//        _localStorage[url] = base64Encode(_memCache[url]);
        return _memCache[url];
      }
    }
  }

  /// Remove a file from the cache
  void removeFile(String url) {
    _localStorage[url] = null;
  }

  /// Removes all files from the cache
  void emptyCache() {
    _localStorage.clear();
  }
}
