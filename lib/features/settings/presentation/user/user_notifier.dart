import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String? avatarPath;
  final String? avatarFilePath;
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? mission;
  final String? workingHours;

  const UserState({
    this.avatarPath,
    this.avatarFilePath,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.mission,
    this.workingHours,
  });

  UserState copyWith({
    String? avatarPath,
    String? avatarFilePath,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? mission,
    String? workingHours,
  }) {
    return UserState(
      avatarPath: avatarPath ?? this.avatarPath,
      avatarFilePath: avatarFilePath ?? this.avatarFilePath,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      mission: mission ?? this.mission,
      workingHours: workingHours ?? this.workingHours,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserState(
      avatarPath: 'assets/images/photo5.png',
      name: 'اسم البائع',
      email: 'seller@example.com',
      phone: '',
      location: 'عمان، الأردن',
      mission: 'رسالتنا هي مساعدة الجميع',
      workingHours: '8 ص - 4 م',
    );
  }

  void updateFullProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
    String? mission,
    String? workingHours,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      email: email ?? state.email,
      phone: phone ?? state.phone,
      location: location ?? state.location,
      mission: mission,
      workingHours: workingHours,
    );
  }

  void updateAvatarFilePath(String? path) {
    state = state.copyWith(avatarFilePath: path, avatarPath: null);
  }
}

final userProvider = NotifierProvider<UserNotifier, UserState>(() {
  return UserNotifier();
});

class UserImageNotifier extends Notifier<Uint8List?> {
  @override
  Uint8List? build() => null;

  void setImage(Uint8List? image) => state = image;
}

final userImageProvider = NotifierProvider<UserImageNotifier, Uint8List?>(() {
  return UserImageNotifier();
});
