import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retreat/models/no_data_retrieved_exception.dart';
import 'package:retreat/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//TODO: throws exception if no user is authenticated.

class ProfileService {
  /// The supabase client for Retreat.
  final client = Supabase.instance.client;

  /// Creates a user profile if a user in authenticated.
  ///
  /// Returns true if a user profile is successfully created,
  /// otherwise returns false.
  Future<bool> insertProfile(context, {required String username}) async {
    final result = await client.from('profiles').insert([
      {'id': client.auth.currentUser?.id, 'username': username}
    ]).execute();

    // check if profile is created successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  /// Updates the username of the currently authenticated user.
  ///
  /// Returns true if the username is successfully updated,
  /// otherwise returns false.
  Future<bool> updateCurrentUserUsername(context,
      {required String username}) async {
    final result = await client
        .from('profiles')
        .update({
          'username': username,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', client.auth.currentUser?.id)
        .execute();

    // check if profile is updated successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  /// Retrieves the profile of the currently authenticaed user.
  Future<Profile> getCurrentUserProfile(context) async {
    final result = await client
        .from('profiles')
        .select()
        .eq('id', client.auth.currentUser?.id)
        .execute();

    // check if profile is retrieved successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }

    final dataList = result.data as List;
    return dataList.map((e) => Profile.fromJson(e)).toList().elementAt(0);
  }

  Future<bool> updateCurrentUserAvatar(context,
      {required String imageUrl}) async {
    final result = await client
        .from('profiles')
        .update({
          'avatar_url': imageUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', client.auth.currentUser?.id)
        .execute();

    // check if avatar is updated successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  Future<void> uploadAvatar(context, {required XFile imageFile}) async {
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
  String _nameFile({required XFile file}) {
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    return fileName;
  }

  /// Retrieved the url of an image named [fileName] from 'avatars' storage.
  ///
  /// Returns the image url as a String if successfully retrieved.
  /// Throws a [NoDataRetrievedException] if the image could not be found.
  Future<String> _getAvatarUrl(context, {required String fileName}) async {
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
}
