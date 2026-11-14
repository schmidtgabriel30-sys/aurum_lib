import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/constants/home_content.dart';
import '../core/theme/app_spacing.dart';

/// Logo da Aurum. Se a imagem não existir, mostra o nome em texto.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = AppSizes.logoLg});

  final double height;

  @override
  Widget build(BuildContext context) => Image.asset(
    HomeContent.logoImage,
    height: height,
    errorBuilder: (_, _, _) => Text(
      AppStrings.logoFallback,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        fontSize: height / 2.4,
      ),
    ),
  );
}
