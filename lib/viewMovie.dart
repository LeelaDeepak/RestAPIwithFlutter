import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movizplaza/movieModel.dart';

class ViewTheMovie extends StatefulWidget {
  final Movie movie;
  const ViewTheMovie({super.key, required this.movie});

  @override
  State<ViewTheMovie> createState() => _ViewTheMovieState();
}

class _ViewTheMovieState extends State<ViewTheMovie> {
  bool useMemoryImg = false;

  // ignore: prefer_typing_uninitialized_variables
  late var imgBytes;
  // Define the maximum rating and the number of stars to display

  @override
  void initState() {
    checkImg();
    super.initState();
  }

  checkImg() {
    if (widget.movie.posterUrl.startsWith('data:image/')) {
      final base64String = widget.movie.posterUrl.split(',').last;
      final decodedBytes = base64.decode(base64String);
      setState(() {
        useMemoryImg = !useMemoryImg;
        imgBytes = decodedBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: AspectRatio(
                aspectRatio: 7 / 9,
                child: (useMemoryImg)
                    ? Image.memory(
                        imgBytes,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.movie.posterUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Text(
              widget.movie.name,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            ListTile(
              leading: (widget.movie.isAdult)
                  ? const Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                      size: 60,
                    )
                  : const Icon(
                      Icons.movie_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
              title: Text(
                widget.movie.desc,
                textAlign: TextAlign.justify,
              ),
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 16),
            ),
            ListTile(
              title: Text(
                "Language : ${widget.movie.language}",
              ),
              titleTextStyle: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              trailing: Text(
                "Released On: ${widget.movie.date}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                  child: Row(
                    children: [
                      const Text(
                        "Genres Covered :  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      _buildGenreChips(widget.movie.genre, 'All'),
                    ],
                  ),
                ))
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                  child: Row(
                    children: [
                      const Text(
                        "Rating :  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      _buildStarRating(widget.movie.rating)
                    ],
                  ),
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  icon: const Icon(Icons.remove_red_eye,size: 30,),
                  label: 
                  const Text('Watch Movie',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  icon: const Icon(Icons.download,size: 30,),
                  label: 
                  const Text('Download Movie',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(rating, (index) {
        if (index < rating) {
          return const Icon(Icons.star, color: Colors.red, size: 30);
        } else {
          return const Icon(Icons.star_border, color: Colors.red, size: 30);
        }
      }),
    );
  }

  // Widget _buildRatingStars(num rating) {
  //   return
  // }

  Widget _buildGenreChips(
    List<String> genres,
    String selectedGenre,
  ) {
    return Wrap(
      spacing: 10,
      children: genres.map((genre) {
        return ActionChip(
          label: Text(genre),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: Colors.red,
          onPressed: () {},
        );
      }).toList(),
    );
  }
}
