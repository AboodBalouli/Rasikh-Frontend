class StoreProfileUpdate {
  final String? newName;
  final String? newBio;

  /// Absolute/local file path for a newly picked avatar, if any.
  final String? newAvatarFilePath;

  final String newLocation;

  const StoreProfileUpdate({
    this.newName,
    this.newBio,
    this.newAvatarFilePath,
    required this.newLocation,
  });
}
