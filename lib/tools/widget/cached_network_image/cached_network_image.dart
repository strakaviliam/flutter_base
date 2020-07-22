
import 'package:flutter/material.dart';

import 'cached_network_image_general.dart'
if (dart.library.io)  'cached_network_image_mobile.dart'
if (dart.library.html) 'cached_network_image_web.dart';

abstract class CachedNetworkImage extends StatelessWidget {

  String url;
  double scale = 1.0;
  double width;
  double height;
  int boxFit;
  Alignment align;
  Map<String, String> headers;

  factory CachedNetworkImage(String url, double width, double height, int boxFit, Alignment align) => getCachedNetworkImage(url, width, height, boxFit, align);

  CachedNetworkImage.protected();
}
