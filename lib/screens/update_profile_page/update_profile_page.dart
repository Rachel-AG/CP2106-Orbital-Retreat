import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/notifiers/current_profile_change_notifier.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                Consumer<CurrentProfileChangeNotifier>(
                  builder: (context, value, child) => profileDisplay(value),
                ),
                updateAvatarButton(),
                const SizedBox(
                  height: 24,
                ),
                CustomFormField(
                  key: const ValueKey('new-username-field'),
                  labelText: 'New Username',
                  controller: _usernameController,
                ),
                updateUsernameButton(),
              ]),
        ),
      ),
    );
  }

  Widget profileDisplay(
      CurrentProfileChangeNotifier currentProfileChangeNotifier) {
    final url = currentProfileChangeNotifier.profile.avatarUrl;
    final username = currentProfileChangeNotifier.profile.username;
    return Column(
      children: [
        url != null
            ? Avatar(
                imageUrl: url,
                size: 160.0,
              )
            : const Avatar(size: 160.0),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          username,
          style: TextStyles.optionTextStyle,
        ),
      ],
    );
  }

  CustomButton updateUsernameButton() {
    return CustomButton(
        text: "Confirm",
        key: const ValueKey('update-username-button'),
        onTap: () {
          Provider.of<CurrentProfileChangeNotifier>(context, listen: false)
              .updateProfile(username: username);
        });
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
          // ignore: use_build_context_synchronously
          Provider.of<CurrentProfileChangeNotifier>(context, listen: false)
              .uploadAvatar(imageFile);
        },
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('New Avatar'));
  }
}
