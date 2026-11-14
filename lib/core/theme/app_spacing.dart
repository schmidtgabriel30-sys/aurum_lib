/// Escala de espaçamentos usada em `padding`, `margin` e `SizedBox`.
///
/// Números soltos no meio do layout dificultam o ajuste fino depois.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Margem lateral padrão das telas.
  static const double screenPadding = 20;
}

/// Raios de borda.
abstract final class AppRadius {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 10;
}

/// Tamanhos fixos de componentes (ícones, botões, imagens e larguras).
abstract final class AppSizes {
  static const double iconXs = 11;
  static const double iconSm = 12;
  static const double iconMd = 14;
  static const double iconLg = 16;
  static const double iconXl = 40;

  static const double iconBox = 30;
  static const double buttonHeight = 44;
  static const double heroImageHeight = 190;
  static const double avatarRadius = 26;
  static const double eyebrowLine = 16;
  static const double checkboxWidth = 24;
  static const double numberColumn = 34;

  static const double logoSm = 26;
  static const double logoMd = 28;
  static const double logoLg = 36;
  static const double logoXl = 40;

  /// Largura máxima do conteúdo em telas grandes (web/desktop).
  static const double maxContentWidth = 480;

  /// Largura máxima das telas de formulário curtas (login, conta).
  static const double maxNarrowWidth = 360;
}
