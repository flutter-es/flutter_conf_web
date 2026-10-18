import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/widgets/container/footer.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_benefits_section.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_hero.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_opportunities_section.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_packages_section.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_pdf_section.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_startup_section.dart';
import 'package:flutter_conf_latam/features/sponsorship/presentation/widgets/sponsorship_why_section.dart';
import 'package:material_ui/material_ui.dart';

class SponsorshipPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SponsorshipPage> createState() => _SponsorshipPageState();
}

class _SponsorshipPageState extends State<SponsorshipPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      analyticsRepository.value.logScreenView(screenName: 'sponsorship_page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            const SponsorshipHero(),
            const SponsorshipWhySection(),
            const SponsorshipPackagesSection(),
            const SponsorshipBenefitsSection(),
            const SponsorshipOpportunitiesSection(),
            const SponsorshipStartupSection(),
            const SponsorshipPdfSection(),
            const Footer(),
          ]),
        ),
      ],
    );
  }
}
