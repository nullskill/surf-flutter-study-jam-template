import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/strings/strings.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, 120);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top + 16;
    return Container(
      color: Theme.of(context).primaryColor,
      height: preferredSize.height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, topPadding, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: chatRoomAuthorInputHint,
                  // TODO: Move to the theme
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  focusColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            // TODO:  Make settings screen
            // IconButton(
            //   icon: const Icon(Icons.settings,
            // color: Theme.of(context).colorScheme.onPrimary,),
            //   onPressed: () {
            //     Navigator.restorablePushNamed(context, settingsRouteName);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
