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
      appBar: AppBar(
        title: const Text(
          "Update Profile",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                  future: ProfileService.getCurrentUserProfile(context),
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
                              snapshot.data!.username,
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
      text: "Confirm New Username",
      onTap: () async {
        await ProfileService.updateCurrentUserUsername(context,
                username: username)
            .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully update profile'),
              duration: Duration(seconds: 2),
            ));
            setState(() {});
            // QUICK FIX FOR UNITY OVERLAY
            Navigator.popUntil(context, ModalRoute.withName('/home'));
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
          await ProfileService.uploadAvatar(context, imageFile: imageFile);

          // QUICK FIX FOR UNITY OVERLAY
          Navigator.popUntil(context, ModalRoute.withName('/home'));

          setState(() {});
        },
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('New Avatar'));
  }
}
