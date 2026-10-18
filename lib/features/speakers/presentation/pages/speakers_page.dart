import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/utils/page_preloader.dart';
import 'package:flutter_conf_latam/core/widgets/container/footer.dart';
import 'package:flutter_conf_latam/core/widgets/container/page_loading.dart';
import 'package:flutter_conf_latam/features/speakers/presentation/view_model/speakers_view_model.dart';
import 'package:flutter_conf_latam/features/speakers/presentation/widgets/speakers_main.dart';
import 'package:material_ui/material_ui.dart';

class SpeakersPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SpeakersPage> createState() => _SpeakersPageState();
}

class _SpeakersPageState extends State<SpeakersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(
      analyticsRepository.value.logScreenView(screenName: 'speakers_page'),
    );
    unawaited(_preloadData());
  }

  Future<void> _preloadData() async {
    await PagePreloader.preload([speakersSignal]);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const PageLoading();

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            const SpeakersMain(),
            const Footer(),
          ]),
        ),
      ],
    );
  }
}
