
import 'package:base/application/environment/environment.dart';
import 'package:base/common/widget/progress_indicator.dart';
import 'package:base/tools/widget/cached_network_image/cached_network_image.dart';
import 'package:base/tools/widget/font_awesome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnyImage extends StatefulWidget {

  var content;
  Color color;
  AnyImage errorImage;
  String value;
  Size size;
  int boxFit = 0;
  int alignH = 0;
  int alignV = 0;
  double opacity = 1.0;

  AnyImage(this.content, {this.color, this.errorImage, String value, this.size, this.boxFit, this.alignH, this.alignV}) {
    this.value = value;
    if (content is String) {
      this.value = value ?? content;
    }
  }

  @override
  State<StatefulWidget> createState() => _AnyImageState();
}

class _AnyImageState extends State<AnyImage> {

  static Map<String, bool> _assetsState = {};

  int boxFit = 0;
  int alignH = 0;
  int alignV = 0;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _setState();
  }

  void _setState() {
    boxFit = widget.boxFit;
    alignH = widget.alignH;
    alignV = widget.alignV;
    opacity = widget.opacity;
  }

  @override
  void didUpdateWidget(AnyImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.boxFit != boxFit || widget.alignV != alignV || widget.alignH != alignH || widget.opacity != opacity) {
      _setState();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    String assetsPrefix = "images/";
    String assetsSuffix = ".png";
    if (!kIsWeb) {
      assetsPrefix = "assets/images/";
    }

    if (widget.content is String) {
      if (widget.content == "") {
        return Container();
      }

      String path = widget.content;
      path = path.replaceAll("images/", "");
      if (path.endsWith(".jpg") || path.endsWith(".jpeg") || path.endsWith(".png")) {
        assetsSuffix = "";
      }

      if (path.startsWith("fa_") && FontAwesomeIcons.faIcons.containsKey(path)) {

        return Container(
          child: LayoutBuilder(builder: (context, constraint) {
            double useWidth = widget.size == null ? constraint.biggest.width : widget.size.width;
            double useHeight = widget.size == null ? constraint.biggest.height : widget.size.height;
            return Center(
              child: Container(
                width: useWidth,
                height: useHeight,
                child: Icon(
                  FontAwesomeIcons.faIcons[path].icon(),
                  color: widget.color ?? Colors.black,
                  size: useHeight > useWidth ? useWidth * 0.8 : useHeight * 0.8,
                ),
              ),
            );
          }),
        );
      }

      if (_assetsState.containsKey(path) && !_assetsState[path]) {
        path = Environment.value.fileserverEndpoint + path;
      }

      if (path.startsWith("http")) {
        //network
        return Container(
          child: Opacity(
            opacity: opacity,
            child: LayoutBuilder(builder: (context, constraint) {
              double useWidth = widget.size == null ? constraint.biggest.width : widget.size.width;
              double useHeight = widget.size == null ? constraint.biggest.height : widget.size.height;
              var image = CachedNetworkImage(path, useWidth, useHeight, boxFit, Alignment((alignH ?? 0).toDouble(), (alignV ?? 0).toDouble()));
              return image;
            }),
          ),
        );

//        return CachedNetworkImage(
//          imageUrl: path,
//          fit: BoxFit.contain,
//          placeholder: (context, url) => Container(padding: EdgeInsets.all(5), child: Progress()),
//          errorWidget: (context, url, error) => widget.errorImage ?? Container(),
//        );
      }

      if (_assetsState.containsKey(path) && _assetsState[path]) {

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

        return Container(
          child: Opacity(
            opacity: opacity,
            child: LayoutBuilder(builder: (context, constraint) {
              double useWidth = widget.size == null ? constraint.biggest.width : widget.size.width;
              double useHeight = widget.size == null ? constraint.biggest.height : widget.size.height;
              var image = Image(
                width: useWidth,
                height: useHeight,
                image: AssetImage(assetsPrefix + path + assetsSuffix),
                fit: _boxFit,
                alignment: Alignment((alignH ?? 0).toDouble(), (alignV ?? 0).toDouble()),
              );
              //this is way how to mask image from assets
              if (widget.color != null) {
                image = Image(
                  width: useWidth,
                  height: useHeight,
                  image: AssetImage(path),
                  color: widget.color,
                  fit: _boxFit,
                  alignment: Alignment((alignH ?? 0).toDouble(), (alignV ?? 0).toDouble()),
                );
              }
              return image;
            }),
          ),
        );
      }

      //check asset
      _checkAssetImage(assetsPrefix + path + assetsSuffix, (exist) {
        _assetsState[path] = exist;
        setState(() {});
      });

      return Container(padding: EdgeInsets.all(5), child: Center(child: Container(width: 30, height: 30, child: Progress(color: Theme.of(context).primaryColor))));

    } else if (widget.content is IconData) {
      //icon
      return Container(
        child: LayoutBuilder(builder: (context, constraint) {
          double useWidth = widget.size == null ? constraint.biggest.width : widget.size.width;
          double useHeight = widget.size == null ? constraint.biggest.height : widget.size.height;
          return Container(
            width: useWidth,
            height: useHeight,
            child: Icon(
              widget.content,
              color: widget.color ?? Colors.black,
              size: useHeight*0.8,
            ),
          );
        }),
      );
    }

    return Container(
      child: Placeholder(),
    );
  }

  void _checkAssetImage(String path, Function(bool) done) async {
    try {
      await rootBundle.load(path);
      done(true);
    } catch(_) {
      done(false);
    }
  }
}
