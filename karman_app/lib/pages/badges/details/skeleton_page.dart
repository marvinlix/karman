import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class SkeletonPage extends StatelessWidget {
  final String title;
  final String animationAsset;
  final String linkText;
  final String linkUrl;
  final List<String> bulletPoints;

  const SkeletonPage({
    super.key,
    required this.title,
    required this.animationAsset,
    required this.linkText,
    required this.linkUrl,
    required this.bulletPoints,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text(title, style: _textStyle.copyWith(fontSize: 18)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Lottie.asset(animationAsset, height: 200),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () => _launchURL(linkUrl),
              child: Text(
                linkText,
                style: _textStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: ListView(
                  children: bulletPoints
                      .map((point) => Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              '• $point',
                              style: _textStyle,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final TextStyle _textStyle = TextStyle(
    fontSize: 18,
    color: CupertinoColors.white,
  );

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
