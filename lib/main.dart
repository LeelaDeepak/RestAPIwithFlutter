import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movizplaza/Helper.dart';
import 'package:movizplaza/movieModel.dart';
import 'package:movizplaza/viewMovie.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showGenres = false;

  @override
  Widget build(BuildContext context) {
    final moviesData = ref.watch(moviesProvider);
    final genres = ref.watch(genreProvider);
    final selectedGenre = ref.watch(selectedGenreProvider);
    final showAdultMovies = ref.watch(showAdultMoviesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final logoUrl = ref.watch(appLogo);
    final anlogoUrl = ref.watch(myanotherApplogo);
    final myjioUrl = ref.watch(jioLogo);
    final lastUrl = ref.watch(fLogo);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildSearchWidget(ref, genres, selectedGenre, showAdultMovies),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Image.network(logoUrl, height: 80)),
                  Expanded(child: Image.network(anlogoUrl, height: 80)),
                  Expanded(child: Image.network(myjioUrl, height: 40)),
                  Expanded(child: Image.network(lastUrl, height: 40)),
                ],
              ),
              _buildViewByGenreButton(),
              const SizedBox(height: 10),
              if (_showGenres) _buildGenreChips(ref, genres, selectedGenre),
              const SizedBox(height: 10),
              moviesData.when(
                data: (movies) {
                  final filteredMovies = movies.where((movie) {
                    final matchesGenre = selectedGenre == 'All' ||
                        movie.genre.contains(selectedGenre);
                    final matchesAdultFilter =
                        !showAdultMovies || movie.isAdult;
                    final matchesSearchQuery = movie.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                    return matchesGenre &&
                        matchesAdultFilter &&
                        matchesSearchQuery;
                  }).toList();
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return _buildImage(movie.posterUrl, movie);
                      },
                    ),
                  );
                },
                error: (error, stack) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Something Went Wrong",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                    ],
                  ),
                ),
                loading: () => Container(
                  margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget(
    WidgetRef ref,
    List<String> genres,
    String selectedGenre,
    bool showAdultMovies,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        onChanged: (query) {
          ref.read(searchQueryProvider.notifier).state = query;
        },
        keyboardType: TextInputType.name,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Search Movie',
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search,
                color: Colors.white,
              ),
              Switch(
                value: showAdultMovies,
                onChanged: (value) {
                  ref.read(showAdultMoviesProvider.notifier).state = value;
                },
                activeColor: Colors.red,
                inactiveTrackColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChips(
    WidgetRef ref,
    List<String> genres,
    String selectedGenre,
  ) {
    return Wrap(
      spacing: 10,
      children: genres.map((genre) {
        final isSelected = genre.startsWith(selectedGenre.split(' ').first);
        return ActionChip(
          label: Text(genre),
          labelStyle:
              TextStyle(color: isSelected ? Colors.white : Colors.white),
          backgroundColor: isSelected ? Colors.red : Colors.grey[800],
          onPressed: () {
            ref.read(selectedGenreProvider.notifier).state =
                genre.split(' ').first;
          },
        );
      }).toList(),
    );
  }

  Widget _buildImage(String imageUrl, Movie movie) {
    if (imageUrl.startsWith('data:image/')) {
      final base64String = imageUrl.split(',').last;
      final decodedBytes = base64.decode(base64String);
      return GestureDetector(
        onTap: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewTheMovie(
                      movie: movie,
                    )),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.memory(
            decodedBytes,
            fit: BoxFit.fitHeight,
            width: double.infinity,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
         
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewTheMovie(
                      movie: movie,
                    )),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitHeight,
            width: double.infinity,
          ),
        ),
      );
    }
  }

  Widget _buildViewByGenreButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showGenres = !_showGenres;
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        child: Text(_showGenres ? 'Hide Genres' : 'View By Genre'),
      ),
    );
  }
}
