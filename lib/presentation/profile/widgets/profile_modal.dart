import 'package:flutter/material.dart';

class ProfileModal extends StatelessWidget {
  final String title;
  final List<Widget> content;

  const ProfileModal({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            width: 400,
            height: 600,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 0.4,
                    indent: 20,
                    endIndent: 20,
                    color: Theme.of(context).dividerColor,
                  ),
                  Expanded(
                    child: ListView(
                      children: content,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
