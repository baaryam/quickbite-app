import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static int getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1100) return 4;
    if (width > 750) return 3;
    if (width > 500) return 2;
    return 1;
  }

  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1100) return 960;
    if (width > 750) return 720;
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100 && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= 650 && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}
