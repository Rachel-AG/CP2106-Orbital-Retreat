
import 'package:image_picker/image_picker.dart';
import 'package:retreat/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO: error handling
class ProfileService {
  /// The supabase client for Retreat.
  static final client = Supabase.instance.client;

  Future<bool> createProfile(String username) async {
    final result = await client.from('profiles').insert([
      {'id': client.auth.currentUser?.id, 'username': username}
    ]).execute();

    // check if profile is created successfully
    if (result.error != null) return false;
    return true;
  }

  Future<Profile> getCurrentProfile() async {
    final result = await client
        .from('profiles')
        .select()
        .eq('id', client.auth.currentUser?.id)
        .execute();

    final dataList = result.data as List;
    return dataList.map((e) => Profile.fromJson(e)).toList().elementAt(0);
  }

    if (dataList.isEmpty) {
      return const Profile('null', 'UserNotFound', '', null);
    }
    return true;
  }

  static Future<void> uploadAvatar(context, {required XFile imageFile}) async {
    final bytes = await imageFile.readAsBytes();
    final fileName = _nameFile(file: imageFile);

    // uploading selected image to supabase storage
    await Supabase.instance.client.storage
        .from('avatars')
        .uploadBinary(fileName, bytes)
        .then(
          (value) => value.error != null
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${value.error!.message.toString()}'),
                  duration: const Duration(seconds: 2)))
              : null,
        );

    // retrieving
    final result = await _getAvatarUrl(context, fileName: fileName);
    await updateCurrentUserAvatar(context, imageUrl: result);
  }

  /// Creates a name for [file] based on current date and time.
  ///
  /// Returns a name with a file extension as a String.
  static String _nameFile({required XFile file}) {
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    return fileName;
  }

  /// Retrieved the url of an image named [fileName] from 'avatars' storage.
  ///
  /// Returns the image url as a String if successfully retrieved.
  /// Throws a [NoDataRetrievedException] if the image could not be found.
  static Future<String> _getAvatarUrl(context,
      {required String fileName}) async {
    final result =
        Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);

    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      throw const NoDataRetrievedException();
    }

    if (result.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No such file is found'),
        duration: Duration(seconds: 2),
      ));
      throw const NoDataRetrievedException();
    }

    return result.data!;
  }

  Future<bool> updateProfile(Profile profile) async {
    final result = await client
        .from('profiles')
        .update({
          'username': profile.username,
          'avatar_url': profile.avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', client.auth.currentUser?.id)
        .execute();

    // check if avatar is updated successfully
    if (result.error != null) return false;
    return true;
  }

  Future<String> uploadAvatar(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final fileName = _nameFile(file: imageFile);

    // uploading selected image to supabase storage
    final result = await Supabase.instance.client.storage
        .from('avatars')
        .uploadBinary(fileName, bytes);

    if (result.error != null) false;

    return await _getAvatarUrl(fileName);
  }

  Future<String> _getAvatarUrl(String fileName) async {
    final result =
        Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);
    return result.data!;
  }

  String _nameFile({required XFile file}) {
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    return fileName;
  }
}
