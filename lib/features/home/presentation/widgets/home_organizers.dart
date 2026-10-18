import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_conf_latam/core/providers/shared_providers.dart';
import 'package:flutter_conf_latam/core/responsive/responsive_context_layout.dart';
import 'package:flutter_conf_latam/core/utils/utils.dart';
import 'package:flutter_conf_latam/core/widgets/container/error_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/keep_alive_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/pagination_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/responsive_grid.dart';
import 'package:flutter_conf_latam/core/widgets/container/section_container.dart';
import 'package:flutter_conf_latam/core/widgets/container/shimmer_container.dart';
import 'package:flutter_conf_latam/core/widgets/images/character_image.dart';
import 'package:flutter_conf_latam/core/widgets/images/single_image.dart';
import 'package:flutter_conf_latam/core/widgets/text/title_subtitle_text.dart';
import 'package:flutter_conf_latam/features/home/presentation/view_model/home_signals.dart';
import 'package:flutter_conf_latam/l10n/localization_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

class OrganizersPeople extends SignalStatefulWidget {
  const new({super.key});

  @override
  State<OrganizersPeople> createState() => _OrganizersPeopleState();
}

class _OrganizersPeopleState extends State<OrganizersPeople> {
  @override
  void initState() {
    super.initState();
    paginationController.update(pageSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;

    final size = switch (context.screenSize) {
      .extraLarge || .large => const Size.square(206),
      .normal || .small => const Size.square(120),
    };

    final organizers = organizersSignal.value;
    return KeepAliveContainer(
      child: SectionContainer(
        spacing: 48,
        children: <Widget>[
          TitleSubtitleText(
            title: (
              text: l10n.organizersPeopleTitle,
              size: switch (context.screenSize) {
                .extraLarge => 64,
                .large => 48,
                .normal || .small => 24,
              },
            ),
            subtitle: (
              text: l10n.organizersPeopleDescription,
              size: switch (context.screenSize) {
                .extraLarge || .large => 24,
                .normal || .small => 16,
              },
            ),
            spacing: 12,
          ),
          organizers.map(
            data: (data) => PaginationContainer(
              totalSize: data.totalList,
              pageSize: paginationController.value.pageSize,
              currentPage: paginationController.value.page,
              onChangedPage: (value) {
                paginationController.update(page: value);
              },
              child: _OrganizerPeopleGrid(
                children: <Widget>[
                  for (final item in data.organizerList)
                    Center(
                      child: Column(
                        spacing: 20,
                        children: <Widget>[
                          CharacterImage(
                            imageUrl: item.user.avatarUrl ?? '',
                            flagImageUrl: item.user.countryFlag ?? '',
                            size: size,
                          ),
                          TitleSubtitleText(
                            title: (
                              text: item.user.name,
                              size: switch (context.screenSize) {
                                .extraLarge || .large => 24,
                                .normal || .small => 12,
                              },
                            ),
                            subtitle: (
                              text: item.areas.map((a) => a.name).join(' - '),
                              size: switch (context.screenSize) {
                                .extraLarge || .large => 16,
                                .normal || .small => 12,
                              },
                            ),
                            spacing: 4,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            loading: () => Shimmer(
              child: _OrganizerPeopleGrid(
                children: .generate(9, (_) {
                  return Center(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Column(
                        spacing: 20,
                        children: <Widget>[
                          SingleImageContainer(size: size, borderRadius: 30),
                          const TitleSubtitleTextContainer(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            error: (_, _) => const ErrorContainer(onRetry: reloadOrganizers),
          ),
        ],
      ),
    );
  }
}

class _OrganizerPeopleGrid extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final colSize = switch (context.screenSize) {
      .extraLarge => 4,
      _ => 2,
    };

    return ResponsiveGrid(
      columnSizes: colSize,
      rowSizes: (children.length / colSize).ceil(),
      children: children,
    );
  }
}

class OrganizersCommunities extends SignalWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appLocalizations.value;
    final communities = communitiesSignal.value;

    return SectionContainer(
      spacing: 30,
      children: <Widget>[
        TitleSubtitleText(
          title: (
            text: l10n.organizersCommunityTitle,
            size: switch (context.screenSize) {
              .extraLarge => 64,
              .large => 48,
              .normal || .small => 24,
            },
          ),
          subtitle: (
            text: l10n.organizersCommunityDescription,
            size: switch (context.screenSize) {
              .extraLarge || .large => 24,
              .normal || .small => 16,
            },
          ),
          spacing: 12,
        ),
        communities.map(
          data: (data) => _OrganizerCommunitiesGrid(
            children: <Widget>[
              for (final item in data)
                InkWell(
                  onTap: () {
                    final socialLink = item.socialLinks?.firstWhereOrNull(
                      (l) => l.type == .website,
                    );

                    if (socialLink != null) {
                      unawaited(Utils.launchUrlLink(socialLink.url));
                    }
                  },
                  child: SingleImage(
                    imageUrl: item.logoUrl ?? '',
                    borderRadius: 20,
                    size: const .fromHeight(180),
                  ),
                ),
            ],
          ),
          loading: () => Shimmer(
            child: _OrganizerCommunitiesGrid(
              children: .generate(9, (_) {
                return const ShimmerLoading(
                  isLoading: true,
                  child: SingleImageContainer(
                    borderRadius: 20,
                    size: .fromHeight(180),
                  ),
                );
              }),
            ),
          ),
          error: (_, _) => ErrorContainer(onRetry: communitiesSignal.reload),
        ),
      ],
    );
  }
}

class _OrganizerCommunitiesGrid extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final colSize = switch (context.screenSize) {
      .extraLarge => 3,
      .large => 2,
      _ => 1,
    };

    return ResponsiveGrid(
      columnSizes: colSize,
      rowSizes: (children.length / colSize).ceil(),
      children: children,
    );
  }
}
