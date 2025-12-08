import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class ImageDetailScreen extends StatelessWidget {
  final List<String> imageUrls;
  final int currentIndex;
  final String? heroTagPrefix;
  final String? contextId;

  const ImageDetailScreen({
    super.key,
    required this.imageUrls,
    required this.currentIndex,
    this.heroTagPrefix,
    this.contextId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const BackAppBar(
        label: "",
      ),
      body: CarouselSlider(
        items: imageUrls.asMap().entries.map((entry) {
          final int index = entry.key;
          final String imageUrl = entry.value;
          final bool isValidUrl =
              imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
          final prefix = heroTagPrefix ?? 'media';
          final context = contextId ?? 'default';
          final heroTag = '$context-$prefix-$index-$imageUrl';
          return Builder(
            builder: (context) => Hero(
              tag: heroTag,
              child: isValidUrl
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/error.png', fit: BoxFit.contain),
                    )
                  : Image.asset('assets/error.png', fit: BoxFit.contain),
            ),
          );
        }).toList(),
        options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            autoPlay: false,
            scrollDirection: Axis.horizontal,
            initialPage: currentIndex),
      ),
    );
  }
}
