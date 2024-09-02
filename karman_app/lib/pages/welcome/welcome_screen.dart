import 'package:flutter/cupertino.dart';
import 'package:karman_app/pages/welcome/welcome_content.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:karman_app/app_shell.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showFinalButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onLastPageReached() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showFinalButton = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                        if (index == welcomePages.length + 1) {
                          _onLastPageReached();
                        } else {
                          _showFinalButton = false;
                          _animationController.reset();
                        }
                      });
                    },
                    children: [
                      _buildWelcomePage(constraints),
                      ...welcomePages.map(
                          (content) => _buildFeaturePage(content, constraints)),
                      _buildFinalPage(constraints),
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return _currentPage < welcomePages.length + 1
                              ? CupertinoButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: const Icon(
                                    CupertinoIcons.chevron_right_circle_fill,
                                    color: CupertinoColors.white,
                                    size: 52,
                                  ),
                                )
                              : _showFinalButton
                                  ? SlideTransition(
                                      position: _slideAnimation,
                                      child: FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: CupertinoButton(
                                          onPressed: _finishOnboarding,
                                          child: const Text(
                                            "Let's rock!",
                                            style: TextStyle(
                                              color: CupertinoColors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 20),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: welcomePages.length + 2,
                        effect: const WormEffect(
                          dotColor: CupertinoColors.systemGrey,
                          activeDotColor: CupertinoColors.white,
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: constraints.maxHeight * 0.1),
        Image.asset('lib/assets/images/icon/icon.png',
            height: constraints.maxHeight * 0.2),
        SizedBox(height: constraints.maxHeight * 0.05),
        const Text(
          'Welcome to karman',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white),
        ),
      ],
    );
  }

  Widget _buildFeaturePage(
      WelcomePageContent content, BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: constraints.maxHeight * 0.1),
        Text(
          content.title,
          style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: constraints.maxHeight * 0.05),
        SizedBox(
          height: constraints.maxHeight * 0.4,
          child: Lottie.asset(
            content.lottieAsset,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.05),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: CupertinoColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalPage(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: constraints.maxHeight * 0.1),
        const Text(
          'Open Source',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white),
        ),
        SizedBox(height: constraints.maxHeight * 0.05),
        SizedBox(
          height: constraints.maxHeight * 0.4,
          child: Lottie.asset(
            'lib/assets/lottie/github.json',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.05),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Karman is an open-source productivity app. Contribute and make it better!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: CupertinoColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
          builder: (context) => AppShell(key: AppShell.globalKey)),
    );
  }
}
