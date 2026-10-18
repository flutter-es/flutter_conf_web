import 'dart:async';

import 'package:flutter_conf_common/flutter_conf_common.dart';
import 'package:flutter_conf_core/flutter_conf_core.dart';
import 'package:flutter_conf_latam/core/dependencies.dart';
import 'package:flutter_conf_latam/core/providers/shared_providers.dart';
import 'package:signals/signals.dart';

final sponsorsSignal = futureSignal<List<SponsorEntity>>(() async {
  final result = await sponsorRepository.value.listActiveSponsors();
  return switch (result) {
    Success(:final data) => data,
    Failure(:final failure) => throw failure,
  };
});

final pastSponsorsSignal = futureSignal<List<SponsorEntity>>(() async {
  final result = await sponsorRepository.value.listAllSponsors();
  return switch (result) {
    Success(:final data) => data.where((s) => !s.isActive).toList(),
    Failure(:final failure) => throw failure,
  };
});

final faqListSignal = futureSignal<List<FaqEntity>>(() async {
  final result = await faqRepository.value.listPublishedFaqs();
  return switch (result) {
    Success(:final data) => data,
    Failure(:final failure) => throw failure,
  };
});

void reloadFaqs() => unawaited(faqListSignal.reload());

final galleryPreviewSignal = futureSignal<List<String>>(() async {
  final storageUrl = appConfig.value.firebaseStorageUrl;

  await Future<void>.delayed(const Duration(seconds: 3));
  return <String>[
    '$storageUrl/gallery%2F06_IMG_FCL.jpg?alt=media&token=484b5873-fc53-454e-a5a9-79d9424ea6c8',
    '$storageUrl/gallery%2F14_IMG_FCL.jpg?alt=media&token=17dc7496-3f06-47ed-a417-d3f73682485f',
    '$storageUrl/gallery%2F16_IMG_FCL.jpg?alt=media&token=d23bbfbd-5fc8-4a1d-a156-95e7b01a03d9',
    '$storageUrl/gallery%2F10_IMG_FCL.jpg?alt=media&token=429c6612-15a2-4db5-a545-e7c822a3cb1b',
    '$storageUrl/gallery%2F26_IMG_FCL.jpg?alt=media&token=d51ac358-aacd-4ec1-a524-c5f6cd74d05a',
    '$storageUrl/gallery%2F33_IMG_FCL.jpg?alt=media&token=6c024ed1-984d-4873-ae21-4da6dccf8ee1',
    '$storageUrl/gallery%2F34_IMG_FCL.jpg?alt=media&token=0e79a9c1-13d4-4402-925d-e6b13229a738',
    '$storageUrl/gallery%2F15_IMG_FCL.jpg?alt=media&token=a14a0693-7d81-4c09-bc90-3377c2648a51',
  ];
});

final organizersDataSignal = futureSignal<List<OrganizerEntity>>(() async {
  final result = await organizerRepository.value.listAllOrganizers();
  return switch (result) {
    Success(:final data) => data,
    Failure(:final failure) => throw failure,
  };
});

typedef OrganizersInfo = ({List<OrganizerEntity> organizerList, int totalList});

final organizersSignal = computed<AsyncState<OrganizersInfo>>(() {
  final dataState = organizersDataSignal.value;

  return dataState.map(
    data: (list) {
      final pagination = paginationController.value;
      final startIndex = (pagination.page - 1) * pagination.pageSize;
      final endIndex = startIndex + pagination.pageSize;

      if (startIndex >= list.length) {
        return AsyncState.data((
          organizerList: <OrganizerEntity>[],
          totalList: 0,
        ));
      }

      return AsyncState.data((
        organizerList: list.sublist(startIndex, endIndex.clamp(0, list.length)),
        totalList: list.length,
      ));
    },
    error: AsyncState<OrganizersInfo>.error,
    loading: AsyncState<OrganizersInfo>.loading,
  );
});

final communitiesSignal = futureSignal<List<CommunityEntity>>(() async {
  final result = await communityRepository.value.listActiveCommunities();
  return switch (result) {
    Success(:final data) => data,
    Failure(:final failure) => throw failure,
  };
});

void reloadOrganizers() {
  unawaited(organizersDataSignal.reload());
  unawaited(communitiesSignal.reload());
}

final pricingSignal = futureSignal<List<TicketPricingEntity>>(() async {
  final result = await ticketPricingRepository.value.listActiveTicketPricing();
  return switch (result) {
    Success(:final data) => data.reversed.toList(),
    Failure(:final failure) => throw failure,
  };
});

void reloadPricing() => unawaited(pricingSignal.reload());

final venueSignal = futureSignal<VenueEntity>(() async {
  final result = await venueRepository.value.getVenueByYear(year: 2026);
  return switch (result) {
    Success(:final data) => data,
    Failure(:final failure) => throw failure,
  };
});

void reloadVenue() => unawaited(venueSignal.reload());
