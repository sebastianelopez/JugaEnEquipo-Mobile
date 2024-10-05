import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, size: 22.h),
                    ),
                    Text(
                      'Create post',
                      style: TextStyle(fontSize: 13.h),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(AppTheme.primary),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.h),
                    ),
                  ),
                  child: Text('Post',
                      style: TextStyle(fontSize: 13.h, color: Colors.white)),
                ),
              ],
            ),
            Expanded(
              child: TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const PhotoOrVideoButton(),
          ],
        ),
      ),
    );
  }
}
