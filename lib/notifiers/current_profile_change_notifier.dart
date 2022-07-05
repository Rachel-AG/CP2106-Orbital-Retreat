import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/profile_service.dart';

class CurrentProfileChangeNotifier extends ChangeNotifier {
  Profile _profile = Profile('null', 'null', 'null', null);
  Profile get profile {
    isUpToDate ? true : getProfile();
    return _profile;
  }

  bool isUpToDate = false;

  Future<void> getProfile() async {
    _profile = await ProfileService.getCurrentProfile();
    isUpToDate = true;
    notifyListeners();
  }

  Future<void> createProfile(String username) async {
    await ProfileService.createProfile(username);
    isUpToDate = false;
    getProfile();
  }

  Future<void> updateProfile({String? username, String? avatarUrl}) async {
    final newProfile = Profile(profile.id, username ?? profile.username,
        profile.updatedAt, avatarUrl ?? profile.avatarUrl);
    await ProfileService.updateProfile(newProfile);
    isUpToDate = false;
    getProfile();
  }

  Future<void> uploadAvatar(XFile imageFile) async {
    final url = await ProfileService.uploadAvatar(imageFile);
    updateProfile(avatarUrl: url);
  }
}
