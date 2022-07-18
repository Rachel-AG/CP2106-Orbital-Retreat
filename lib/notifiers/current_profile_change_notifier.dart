import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/profile_service.dart';

class CurrentProfileChangeNotifier extends ChangeNotifier {
  final ProfileService _profileService;
  CurrentProfileChangeNotifier(this._profileService);

  Profile _profile = const Profile('null', 'null', 'null', null);
  Profile get profile {
    isUpToDate ? true : getProfile();
    return _profile;
  }

  bool isUpToDate = false;

  Future<void> getProfile() async {
    _profile = await _profileService.getCurrentProfile();
    isUpToDate = true;
    notifyListeners();
  }

  Future<void> createProfile(String username) async {
    await _profileService.createProfile(username);
    isUpToDate = false;
    getProfile();
  }

  Future<void> updateProfile({String? username, String? avatarUrl}) async {
    final newProfile = Profile(profile.id, username ?? profile.username,
        profile.updatedAt, avatarUrl ?? profile.avatarUrl);
    await _profileService.updateProfile(newProfile);
    isUpToDate = false;
    getProfile();
  }

  Future<void> uploadAvatar(XFile imageFile) async {
    final url = await _profileService.uploadAvatar(imageFile);
    updateProfile(avatarUrl: url);
  }

  void reset() {
    _profile = const Profile('null', 'null', 'null', null);
    isUpToDate = false;
  }
}
