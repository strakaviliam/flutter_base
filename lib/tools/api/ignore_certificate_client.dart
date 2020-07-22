
import 'dart:io';

import 'package:http/io_client.dart';

class IgnoreCertificateClient extends IOClient {

  IgnoreCertificateClient() : super(HttpClient()..badCertificateCallback = _certificateCheck);

  static bool _certificateCheck(X509Certificate cert, String host, int port) => true;
}
