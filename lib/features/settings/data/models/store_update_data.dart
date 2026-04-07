import 'dart:io';

class StoreUpdateData {
  final String? newName;
  final String? newBio;
  final File? newAvatarFile;
  final String newLocation;

  StoreUpdateData({
    this.newName,
    this.newBio,
    this.newAvatarFile,
    required this.newLocation,
  });
}
