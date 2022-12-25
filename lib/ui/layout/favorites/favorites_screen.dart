import 'package:movie_app/library.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoritesProvider>(
        create: (_) => FavoritesProvider(),
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: () async {
              context.watch<FavoritesProvider>().fetchFavoriteMovieList();
            },
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: context
                          .watch<FavoritesProvider>()
                          .fetchFavoriteMovieList(),
                      builder: (context, dataSnapshot) {
                        {
                          return Consumer<FavoritesProvider>(
                            builder: (context, list, child) {
                              List<MoviesDetailsModel> myList =
                                  list.getFavoriteMovieList;
                              return GridView.count(
                                shrinkWrap: false,
                                crossAxisCount: 2,
                                children: List.generate(
                                    list.getFavoriteMovieList.length, (index) {
                                  return FavoritesMoviesCard(
                                      movie: myList[index]);
                                }),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  //NewPlayingPoster()
                ],
              ),
            ),
          );
        });
  }
}

class FavoritesMoviesCard extends StatelessWidget {
  final MoviesDetailsModel movie;

  const FavoritesMoviesCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => MovieDetailsScreen(
              movie: movie,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: SizedBox(
          height: context.height * 0.15,
          width: context.width * 0.01,
          child: CachedNetworkImage(
            imageBuilder: (
              context,
              imageProvider,
            ) =>
                Container(
              // height: context.height * 0.5,
              // width: context.width * 0.34,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
            imageUrl: "https://image.tmdb.org/t/p/w200${movie.posterPath!}",
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
