import 'package:karman_app/pages/badges/details/skeleton_page.dart';

final supportPage = SkeletonPage(
  title: 'Support',
  animationAsset: 'lib/assets/lottie/support.json',
  linkText: 'Support the Project',
  linkUrl: 'https://github.com/sponsors/surtecha',
  bulletPoints: const [
    'Karman is a non-profit project',
    'Relies on donations for maintenance',
    'Help keep the app accessible to all',
    'Your support makes a difference',
  ],
);