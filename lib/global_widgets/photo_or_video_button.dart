import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class PhotoOrVideoButton extends StatelessWidget {
  const PhotoOrVideoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    UserModel? user = Provider.of<UserProvider>(context).user;

    return Column(
      children: [
        SizedBox(
          height: 100.h,
          width: double.infinity,
          child: imageProvider.previewImages(),
        ),
        ElevatedButton(
          onPressed: () async => {
            if (user != null)
              await imageProvider.showOptions(context,
                  imageType: ImageType.post, userId: user.id)
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const BeveledRectangleBorder(),
          ),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0.h,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.image,
                  size: 24.h,
                ),
                const Text('Photo / Video')
              ],
            ),
          ),
        ),
      ],
    );
  }
}
