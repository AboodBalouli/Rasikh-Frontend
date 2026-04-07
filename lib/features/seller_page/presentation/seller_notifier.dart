//import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';

class SellerState {
  final String? storeName;
  final String? storeLocation;
  final String? description;
  final double rating;
  final String? avatarPath;
  final String? avatarFilePath;
  final String? phone;
  final String? workingHours;

  const SellerState({
    this.storeName,
    this.storeLocation,
    this.description,
    this.rating = 0.0,
    this.avatarPath,
    this.avatarFilePath,
    this.phone,
    this.workingHours,
  });

  SellerState copyWith({
    String? storeName,
    String? storeLocation,
    String? description,
    double? rating,
    String? avatarPath,
    String? avatarFilePath,
    String? phone,
    String? workingHours,
  }) {
    return SellerState(
      storeName: storeName ?? this.storeName,
      storeLocation: storeLocation ?? this.storeLocation,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      avatarPath: avatarPath ?? this.avatarPath,
      avatarFilePath: avatarFilePath ?? this.avatarFilePath,
      workingHours: workingHours ?? this.workingHours,
      phone: phone ?? this.phone,
    );
  }
}

class SellerNotifier extends StateNotifier<SellerState> {
  SellerNotifier([SellerState? initial])
    : super(initial ?? const SellerState());

  void updateData({
    String? newStoreName,
    String? newStoreLocation,
    String? newDescription,
    String? newAvatarFilePath,
    String? newAvatarPath,
    String? phone,
    String? workingHours,
  }) {
    state = state.copyWith(
      storeName: newStoreName,
      storeLocation: newStoreLocation,
      description: newDescription,
      avatarFilePath: newAvatarFilePath,
      avatarPath: newAvatarPath,
      phone: phone ?? state.phone,
      workingHours: workingHours ?? state.workingHours,
    );
  }

  void updateRating(double r) {
    state = state.copyWith(rating: r);
  }
}

final sellerProvider = StateNotifierProvider<SellerNotifier, SellerState>((
  ref,
) {
  return SellerNotifier(
    const SellerState(
      storeName: 'My Store ',
      storeLocation: ' Jordan , Amman ',
      description: ' الوصف الافتراضي للمتجر.',
      rating: 4.5,
      avatarPath: 'assets/images/photo5.png',
      phone: "0700000000",
      workingHours: "09:00 AM - 10:00 PM",
    ),
  );
});
