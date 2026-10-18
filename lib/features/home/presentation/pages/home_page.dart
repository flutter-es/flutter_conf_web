import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/utils/page_preloader.dart';
import 'package:flutter_conf_latam/core/widgets/container/footer.dart';
import 'package:flutter_conf_latam/core/widgets/container/page_loading.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_collaborations.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_contact.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_features.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_gallery.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_main.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_novelties.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_pricing.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_speakers.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_sponsors.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_timeline.dart';
import 'package:flutter_conf_latam/features/home/presentation/widgets/home_venue.dart';
import 'package:material_ui/material_ui.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(analyticsRepository.value.logScreenView(screenName: 'home_page'));
    unawaited(_preloadData());
  }

  Future<void> _preloadData() async {
    await PagePreloader.preload([
      sponsorsSignal,
      pricingSignal,
      venueSignal,
      organizersDataSignal,
      communitiesSignal,
      faqListSignal,
    ]);

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const PageLoading();

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            const HomeMain(),
            const HomeVenue(),
            const HomeFeatures(),
            const HomeNovelties(),
            const HomeSponsors(),
            const HomePricing(),
            const HomeCollaborations(),
            const HomeTimeline(),
            const HomeSpeakers(),
            // TODO(FV): Uncomment when is ready
            // const OrganizersPeople(),
            // const OrganizersCommunities(),
            const HomeGallery(),
            // TODO(FV): Uncomment when is ready
            // const HomeFaq(),
            const HomeContact(),
            const Footer(),
          ]),
        ),
      ],
    );
  }
}
