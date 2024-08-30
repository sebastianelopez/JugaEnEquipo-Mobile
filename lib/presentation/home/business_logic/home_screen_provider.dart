import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class HomeScreenProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  HomeScreenProvider() {
    initData();
  }

  bool isLoading = false;

  List<PostModel> postsmocks = [
    PostModel(
        user: UserModel(
            id: "asdasdsad",
            userName: "CarlosKret",
            firstName: "Carlos",
            lastName: "Sanchez",
            email: "",
            profileImage: "",
            team: TeamModel(name: "KruSports", members: [])),
        copy: "Acabo de llegar a diamond en Overwatch!",
        images: [
          "https://elcomercio.pe/resizer/gBmn3MDLU8MJ5lfROXomXggJZeg=/1200x675/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/J5TZJL65YBB2JN5TCPZBJVNJTQ.webp"
        ],
        postDate: "2024-04-21 19:18:04Z",
        likes: 20,
        comments: 2,
        shares: 2),
    PostModel(
        user: UserModel(
          id: "asdasdsad12",
          userName: "ski",
          firstName: "Pepe",
          lastName: "Lopez",
          email: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        images: [
          "https://static.wikia.nocookie.net/onepiece/images/e/e6/Tony_Tony_Chopper_Anime_Pre_Timeskip_Infobox.png/revision/latest?cb=20230906213030",
          "https://i.redd.it/ibi67xqqx4ca1.jpg"
        ],
        postDate: "2024-04-20 20:18:04Z",
        likes: 12,
        comments: 2,
        shares: 3),
    PostModel(
        user: UserModel(
          id: "asdasdsad12",
          userName: "ski",
          firstName: "Pepe",
          lastName: "Lopez",
          email: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        images: [
          "https://static0.cbrimages.com/wordpress/wp-content/uploads/2023/12/luffy-from-one-piece.jpg",
          "https://fotografias-neox.atresmedia.com/clipping/cmsimages01/2022/06/10/DE6907B4-E712-4EC9-BF65-023888E1B1A0/one-piece_98.jpg?crop=640,360,x0,y0&width=1900&height=1069&optimize=high&format=webply",
          "https://los40.com/resizer/v2/WLO23UJSQRCMJMEIQP5VQUKJBY.jpg?auth=4e87f3b5ceef9a2e478c9939475644028687387ccb64d7bdd7d6ea1de20d44db&quality=70&width=1200&height=544&smart=true"
        ],
        postDate: "2024-04-20 20:18:04Z",
        likes: 12,
        comments: 2,
        shares: 3),
    PostModel(
        user: UserModel(
          id: "asdasdsad12",
          userName: "ski",
          firstName: "Pepe",
          lastName: "Lopez",
          email: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        images: [
          "https://www.mundodeportivo.com/alfabeta/hero/2023/10/luffy-gear-5-one-piece.jpg?width=768&aspect_ratio=16:9&format=nowebp",
          "https://elcomercio.pe/resizer/Rtcoyz_vKdlOa1Jp9I4-j_4QWKk=/1200x1200/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/37OWRM2CLBAE7BP5SXKLVMNHZE.jpg",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFd4fEi4Rzoi_NZQgxBZdDSqXJdkST1qAMYw&s",
          "https://www.mundodeportivo.com/alfabeta/hero/2021/02/Los-personajes-de-One-Piece-lucen-increibles-en-esta-ilustracion-lenticular.jpg?width=1200&aspect_ratio=16:9"
        ],
        postDate: "2024-04-20 20:18:04Z",
        likes: 12,
        comments: 2,
        shares: 3),
    PostModel(
        user: UserModel(
          id: "asdasdsad12",
          userName: "ski",
          firstName: "Pepe",
          lastName: "Lopez",
          email: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        images: [
          "https://static.vecteezy.com/system/resources/previews/013/993/061/non_2x/mugiwara-the-illustration-vector.jpg",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtgWnCgM69F1C_FQAbCb6MLmK93dwkza04ow&s",
          "https://images.alphacoders.com/135/thumb-1920-1351736.jpeg",
          "https://imgmedia.larepublica.pe/640x371/larepublica/original/2024/04/30/663176e644910638d1405699.webp",
          "https://hips.hearstapps.com/hmg-prod/images/one-piece-netflix-live-action-11-64f06e9522650.jpg?crop=1xw:0.84375xh;center,top&resize=1200:*"
        ],
        postDate: "2024-04-20 20:18:04Z",
        likes: 12,
        comments: 2,
        shares: 3),
    PostModel(
        user: UserModel(
          id: "asdasdsad12",
          userName: "ski",
          firstName: "Pepe",
          lastName: "Lopez",
          email: "",
          profileImage: "",
        ),
        copy: "Acabo de llegar a diamond en Overwatch!",
        images: [
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxm11wE3lA_eqSXv52Tm17WLnGIN4iRZBaWQ&s",
          "https://www.mundodeportivo.com/alfabeta/hero/2023/03/zoro-arbol-genealogico-revelado.jpg?width=768&aspect_ratio=16:9&format=nowebp",
          "https://vanessa-mae.com.ar/wp-content/uploads/how-old-is-binks-sake.webp",
          "https://animeargentina.net/wp-content/uploads/2024/04/jinbe-min-1024x640.jpg",
          "https://www.dexerto.com/cdn-cgi/image/width=3840,quality=60,format=auto/https://editors.dexerto.com/wp-content/uploads/2023/04/26/one-piece-trafalgar-law.jpeg",
          "https://static1.cbrimages.com/wordpress/wp-content/uploads/2022/11/eustasss-captain-kid.jpg"
        ],
        postDate: "2024-04-20 20:18:04Z",
        likes: 12,
        comments: 2,
        shares: 3),
  ];

  Future<void> initData() async {
    isLoading = true;
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) >=
          scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    /* final lastId = imageIds.last;
    imageIds.clear();
    imageIds.add(lastId + 1); */
    // add5();
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    /* setState(() {}); */

    await Future.delayed(const Duration(seconds: 3));

    add5();

    isLoading = false;
    /* setState(() {}); */

    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return;
    scrollController.animateTo(scrollController.position.pixels + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  void add5() {
    /* final lastId = imageIds.last;

    imageIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
    setState(() {}); */
  }
}
