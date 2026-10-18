import 'dart:async';

import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/widgets/container/footer.dart';
import 'package:flutter_conf_latam/features/privacy_terms/presentation/view_model/privacy_terms_view_model.dart';
import 'package:flutter_conf_latam/features/privacy_terms/presentation/widgets/markdown_container.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class PrivacyPage extends SignalStatefulWidget {
  const new({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      analyticsRepository.value.logScreenView(screenName: 'privacy_page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            const _PrivacyMain(),
            const Footer(),
          ]),
        ),
      ],
    );
  }
}

class _PrivacyMain extends SignalWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final privacyPolicyData = privacyPolicySignal.value;
    return privacyPolicyData.maybeMap(
      data: (data) => MarkdownContainer(markdownData: data),
      orElse: () => const Offstage(),
    );
  }
}
