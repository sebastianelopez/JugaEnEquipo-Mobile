import 'package:flutter/material.dart';
import 'package:jugaenequipo/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: BackAppBar(
            label: AppLocalizations.of(context)!.profilePageLabel,
          )),
      body: const FadeInImage(
        placeholder: AssetImage('assets/placeholder.png'),
        image: NetworkImage(
            'https://static.wikia.nocookie.net/onepiece/images/a/af/Monkey_D._Luffy_Anime_Dos_A%C3%B1os_Despu%C3%A9s_Infobox.png/revision/latest?cb=20200616015904&path-prefix=es'),
        fit: BoxFit.cover,
      ),
    );
  }
}
