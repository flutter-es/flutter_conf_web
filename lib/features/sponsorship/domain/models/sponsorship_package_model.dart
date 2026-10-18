import 'package:flutter/foundation.dart';

enum SponsorshipTier { platinum, gold, silver, bronze }

@immutable
class SponsorshipPackageModel {
  const new({
    required this.tier,
    required this.regularPrice,
    required this.promoPrice,
    required this.vipTickets,
    required this.hasTalk,
    this.standSize,
  });

  final SponsorshipTier tier;
  final int regularPrice;
  final int promoPrice;
  final int vipTickets;
  final String? standSize;
  final bool hasTalk;

  static const List<SponsorshipPackageModel> packages = [
    SponsorshipPackageModel(
      tier: SponsorshipTier.platinum,
      regularPrice: 6000,
      promoPrice: 5000,
      vipTickets: 5,
      standSize: '6×2 m',
      hasTalk: true,
    ),
    SponsorshipPackageModel(
      tier: SponsorshipTier.gold,
      regularPrice: 5000,
      promoPrice: 4000,
      vipTickets: 3,
      standSize: '4×2 m',
      hasTalk: true,
    ),
    SponsorshipPackageModel(
      tier: SponsorshipTier.silver,
      regularPrice: 4000,
      promoPrice: 3000,
      vipTickets: 2,
      standSize: '2×2 m',
      hasTalk: false,
    ),
    SponsorshipPackageModel(
      tier: SponsorshipTier.bronze,
      regularPrice: 2500,
      promoPrice: 2000,
      vipTickets: 1,
      hasTalk: false,
    ),
  ];
}
