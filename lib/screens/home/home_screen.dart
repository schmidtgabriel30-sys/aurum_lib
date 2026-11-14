import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../services/auth_service.dart';
import 'sections/cta_section.dart';
import 'sections/essence_section.dart';
import 'sections/faq_section.dart';
import 'sections/footer_section.dart';
import 'sections/header_bar.dart';
import 'sections/hero_section.dart';
import 'sections/includes_section.dart';
import 'sections/offer_section.dart';
import 'sections/promo_bar.dart';
import 'sections/steps_section.dart';
import 'sections/why_section.dart';

/// Página inicial: apresenta a revisão e leva ao agendamento.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _schedule(BuildContext context) =>
      context.goNamed(AppRoutes.appointmentNew);

  Future<void> _signOut(BuildContext context) async {
    await AuthService.instance.signOut();
    if (context.mounted) context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reconstrói o cabeçalho quando o usuário entra ou sai.
                ListenableBuilder(
                  listenable: AuthService.instance,
                  builder: (context, _) => HeaderBar(
                    user: AuthService.instance.currentUser,
                    signedIn: AuthService.instance.isSignedIn,
                    onSchedule: () => _schedule(context),
                    onSignOut: () => _signOut(context),
                  ),
                ),
                const PromoBar(),
                HeroSection(onSchedule: () => _schedule(context)),
                OfferSection(onSchedule: () => _schedule(context)),
                const IncludesSection(),
                const WhySection(),
                const StepsSection(),
                EssenceSection(onSchedule: () => _schedule(context)),
                const FaqSection(),
                CtaSection(
                  onSchedule: () => _schedule(context),
                  onSeeAppointments: () =>
                      context.goNamed(AppRoutes.appointments),
                ),
                const FooterSection(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
