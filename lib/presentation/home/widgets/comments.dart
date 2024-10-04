import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/comments_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Comments extends StatelessWidget {
  final bool autofocus;

  const Comments({super.key, required this.autofocus});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);

    return GestureDetector(
      onTap: () {
        homeProvider.setFocus(false);
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
        height: homeProvider.hasFocus
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * .6,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SafeArea(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.commentsModalLabel,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 0.4,
              indent: 20,
              endIndent: 0,
              color: Colors.grey,
            ),
            Expanded(
              child: ChangeNotifierProvider(
                create: (context) => HomeScreenProvider(),
                child: const CommentsList(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2.h,
                    blurRadius: 5.h,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                autofocus: autofocus,
                onTap: () {
                  homeProvider.setFocus(true);
                },
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Escribe un comentario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
