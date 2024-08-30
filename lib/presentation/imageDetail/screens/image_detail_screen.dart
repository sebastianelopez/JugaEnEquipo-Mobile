import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';

class ImageDetailScreen extends StatelessWidget {
  final List<String> imageUrls;
  final int currentIndex;

  const ImageDetailScreen(
      {Key? key, required this.imageUrls, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 40),
        child: BackAppBar(
          label: "",
        ),
      ),
      body: CarouselSlider(
        items: imageUrls.map((imageUrl) {
          return Builder(
            builder: (context) => Hero(
              tag: imageUrl,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
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
