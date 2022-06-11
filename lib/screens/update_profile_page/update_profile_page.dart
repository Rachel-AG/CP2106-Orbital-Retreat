import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/profile_service.dart';
import 'package:retreat/widgets/avatar.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePage();
}

class _UpdateProfilePage extends AuthRequiredState<UpdateProfilePage> {
  final _supabaseClient = ProfileService();
  final TextEditingController _usernameController = TextEditingController();

  String get username => _usernameController.text.trim();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 24,
              ),
              // email form
              FutureBuilder<Profile>(
                  future: _supabaseClient.getCurrentUserProfile(context),
                  builder: (context, AsyncSnapshot<Profile> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data?.avatarUrl != null) {
                        return Column(
                          children: [
                            Avatar(
                              imageUrl: snapshot.data!.avatarUrl!,
                              size: 160.0,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              snapshot.data!.username!,
                              style: TextStyles.optionTextStyle,
                            ),
                          ],
                        );
                      }
                      return const Avatar();
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              updateAvatarButton(),
              const SizedBox(
                height: 24,
              ),
              CustomFormField(
                labelText: 'New Username',
                controller: _usernameController,
              ),
              updateUsernameButton(),
            ]),
      ),
    );
  }

  CustomButton updateUsernameButton() {
    return CustomButton(
      text: "Confirm",
      onTap: () async {
        await _supabaseClient
            .updateCurrentUserUsername(context, username: username)
            .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully update profile'),
              duration: Duration(seconds: 2),
            ));
            setState(() {});
          }
        });
      },
    );
  }

  ElevatedButton updateAvatarButton() {
    return ElevatedButton.icon(
        onPressed: () async {
          final picker = ImagePicker();
          final imageFile = await picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 300,
            maxHeight: 300,
          );

          if (imageFile == null) {
            return;
          }
          await _supabaseClient.uploadAvatar(context, imageFile: imageFile);
          setState(() {});
        },
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('New Avatar'));
  }
}
