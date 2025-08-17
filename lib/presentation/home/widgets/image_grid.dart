import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/imageDetail/screens/image_detail_screen.dart';

class ImageGrid extends StatelessWidget {
  final List<String> images;

  const ImageGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final int imageCount = images.length;
    final double imageSize = MediaQuery.of(context).size.width;

    if (imageCount == 1) {
      // Single image - occupy full size
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ImageDetailScreen(imageUrls: images, currentIndex: 0),
            ),
          );
        },
        child: Hero(
          tag: images[0],
          child: FadeInImage(
            placeholder: const AssetImage('assets/placeholder.png'),
            image: ((images[0].startsWith('http://') ||
                    images[0].startsWith('https://'))
                ? NetworkImage(images[0])
                : const AssetImage('assets/error.png')) as ImageProvider,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) =>
                imageErrorBuilder(context, error, stackTrace, imageSize),
          ),
        ),
      );
    } else if (imageCount <= 2) {
      // Two images - share width
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageDetailScreen(imageUrls: images, currentIndex: 0),
                  ),
                );
              },
              child: Hero(
                tag: images[0],
                child: FadeInImage(
                  placeholder: const AssetImage('assets/placeholder.png'),
                  image: ((images[0].startsWith('http://') ||
                          images[0].startsWith('https://'))
                      ? NetworkImage(images[0])
                      : const AssetImage('assets/error.png')) as ImageProvider,
                  width: imageSize / 2,
                  height: imageSize / 2, // Adjust height as needed
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      imageErrorBuilder(
                          context, error, stackTrace, imageSize / 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageDetailScreen(imageUrls: images, currentIndex: 1),
                  ),
                );
              },
              child: Hero(
                tag: images[1],
                child: FadeInImage(
                  placeholder: const AssetImage('assets/placeholder.png'),
                  image: ((images[1].startsWith('http://') ||
                          images[1].startsWith('https://'))
                      ? NetworkImage(images[1])
                      : const AssetImage('assets/error.png')) as ImageProvider,
                  width: imageSize / 2,
                  height: imageSize / 2,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      imageErrorBuilder(
                          context, error, stackTrace, imageSize / 2),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (imageCount <= 4) {
      // Three or four images - two rows
      return GridView.count(
        shrinkWrap: true, // Prevent excessive scrolling
        crossAxisCount: 2,
        childAspectRatio:
            imageSize / (imageSize / 2), // Adjust based on desired aspect ratio
        children: List.generate(
            imageCount,
            (index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                            imageUrls: images, currentIndex: index),
                      ),
                    );
                  },
                  child: Hero(
                    tag: images[index],
                    child: FadeInImage(
                        placeholder: const AssetImage('assets/placeholder.png'),
                        image: ((images[index].startsWith('http://') ||
                                    images[index].startsWith('https://'))
                                ? NetworkImage(images[index])
                                : const AssetImage('assets/error.png'))
                            as ImageProvider,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            imageErrorBuilder(context, error, stackTrace)),
                  ),
                )),
      );
    } else {
      // Five or more images - two in first row, three in second
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                            imageUrls: images, currentIndex: 0),
                      ),
                    );
                  },
                  child: Hero(
                    tag: images[0],
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/placeholder.png'),
                      image: ((images[0].startsWith('http://') ||
                                  images[0].startsWith('https://'))
                              ? NetworkImage(images[0])
                              : const AssetImage('assets/error.png'))
                          as ImageProvider,
                      width: imageSize / 2,
                      height: imageSize / 2,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          imageErrorBuilder(
                              context, error, stackTrace, imageSize / 2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                            imageUrls: images, currentIndex: 1),
                      ),
                    );
                  },
                  child: Hero(
                    tag: images[1],
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/placeholder.png'),
                      image: ((images[1].startsWith('http://') ||
                                  images[1].startsWith('https://'))
                              ? NetworkImage(images[1])
                              : const AssetImage('assets/error.png'))
                          as ImageProvider,
                      width: imageSize / 2,
                      height: imageSize / 2,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          imageErrorBuilder(
                              context, error, stackTrace, imageSize / 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                            imageUrls: images, currentIndex: 2),
                      ),
                    );
                  },
                  child: Hero(
                    tag: images[2],
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/placeholder.png'),
                      image: ((images[2].startsWith('http://') ||
                                  images[2].startsWith('https://'))
                              ? NetworkImage(images[2])
                              : const AssetImage('assets/error.png'))
                          as ImageProvider,
                      width: imageSize / 3,
                      height: imageSize / 3,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          imageErrorBuilder(
                              context, error, stackTrace, imageSize / 3),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                            imageUrls: images, currentIndex: 3),
                      ),
                    );
                  },
                  child: Hero(
                    tag: images[3],
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/placeholder.png'),
                      image: ((images[3].startsWith('http://') ||
                                  images[3].startsWith('https://'))
                              ? NetworkImage(images[3])
                              : const AssetImage('assets/error.png'))
                          as ImageProvider,
                      width: imageSize / 3,
                      height: imageSize / 3,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          imageErrorBuilder(
                              context, error, stackTrace, imageSize / 3),
                    ),
                  ),
                ),
              ),

              imageCount > 5
                  ? Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 0.2, // Adjust opacity as desired
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageDetailScreen(
                                        imageUrls: images, currentIndex: 4),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: images[4],
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/placeholder.png'),
                                  image: ((images[4].startsWith('http://') ||
                                          images[4].startsWith('https://'))
                                      ? NetworkImage(images[4])
                                      : const AssetImage(
                                          'assets/error.png')) as ImageProvider,
                                  width: imageSize / 3,
                                  height: imageSize / 3,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error,
                                          stackTrace) =>
                                      imageErrorBuilder(context, error,
                                          stackTrace, imageSize / 3),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "+ ${imageCount - 5}", // Display remaining image count
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageDetailScreen(
                                  imageUrls: images, currentIndex: 4),
                            ),
                          );
                        },
                        child: Hero(
                          tag: images[4],
                          child: FadeInImage(
                            placeholder:
                                const AssetImage('assets/placeholder.png'),
                            image: ((images[4].startsWith('http://') ||
                                        images[4].startsWith('https://'))
                                    ? NetworkImage(images[4])
                                    : const AssetImage('assets/error.png'))
                                as ImageProvider,
                            width: imageSize / 3,
                            height: imageSize / 3,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                imageErrorBuilder(
                                    context, error, stackTrace, imageSize / 3),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ), // Empty space if less than 6 images
            ],
          ),
        ],
      );
    }
  }
}

Widget imageErrorBuilder(
    BuildContext context, Object error, StackTrace? stackTrace,
    [double? imageSize]) {
  return Image.asset(
    'assets/error.png',
    width: imageSize,
    height: imageSize,
    fit: BoxFit.cover,
  );
}
