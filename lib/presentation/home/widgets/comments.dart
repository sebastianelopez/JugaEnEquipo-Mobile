import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class Comments extends StatelessWidget {
  final bool autofocus;
  final String postId;
  final VoidCallback? onCommentAdded;

  const Comments({
    super.key,
    required this.autofocus,
    required this.postId,
    this.onCommentAdded,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => PostProvider(postId: postId),
      child: GestureDetector(
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
              Divider(
                height: 20,
                thickness: 0.4,
                indent: 20,
                endIndent: 0,
                color: Theme.of(context).dividerColor,
              ),
              const Expanded(
                child: CommentsList(),
              ),
              CommentsBottomBar(
                autofocus: autofocus,
                postId: postId,
                onCommentAdded: onCommentAdded,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
