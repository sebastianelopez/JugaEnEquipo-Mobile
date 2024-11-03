import 'package:flutter/material.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class ChatBottomBar extends StatelessWidget {
  const ChatBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Preferences.isDarkmode;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.grey[900] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('hola');
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.grey[900],
                    ),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppTheme.primary,
                elevation: 0,
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
