import 'package:flutter/material.dart';
import '../../core/api.dart';
import 'sections/header_bar.dart';
import 'sections/hero_section.dart';
import 'sections/offer_section.dart';
import 'sections/includes_section.dart';
import 'sections/why_section.dart';
import 'sections/steps_section.dart';
import 'sections/essence_section.dart';
import 'sections/faq_section.dart';
import 'sections/booking_form.dart';
import 'sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey();
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await Api.me();
    if (mounted) setState(() => _user = u);
  }

  Future<void> _logout() async {
    await Api.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  void _goToForm() => Scrollable.ensureVisible(_formKey.currentContext!,
      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  HeaderBar(onSchedule: _goToForm, user: _user, onLogout: _logout),
                  const PromoBar(),
                  HeroSection(onSchedule: _goToForm),
                  OfferSection(onSchedule: _goToForm),
                  const IncludesSection(),
                  const WhySection(),
                  const StepsSection(),
                  EssenceSection(onSchedule: _goToForm),
                  const FaqSection(),
                  KeyedSubtree(key: _formKey, child: const BookingForm()),
                  const FooterSection(),
                ]),
              ),
            ),
          ),
        ),
      );
}