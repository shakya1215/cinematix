import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/api.dart';
import 'models/trailerModel.dart';

class PreloadContent extends StatefulWidget {
  final int movieId;

  const PreloadContent(this.movieId, {Key? key}) : super(key: key);

  @override
  State<PreloadContent> createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  late Stream<List<TrailerModel>> _trailersStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to fetch trailers for the given movie ID
    _trailersStream = Api().getTrailerStream(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _trailersStream,
      builder: (BuildContext context, AsyncSnapshot<List<TrailerModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while fetching trailers
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if trailers are not found
          return Text('Did not find a Trailer');
        } else if (snapshot.hasData) {
          // Display the trailers if available
          return TrailerPage(snapshot);
        } else {
          // Display a message if trailers are not found
          return Text(
            'Did not find a Trailer',
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }
}

class TrailerPage extends StatefulWidget {
  final AsyncSnapshot<List<TrailerModel>> snapshot;

  const TrailerPage(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.of(context).size.width - 16) / 2;

    return GridView.count(
      padding: EdgeInsets.all(0),
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / 155),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      children: List<Widget>.generate(widget.snapshot.data!.length, (index) {
        return GridTile(
          child: InkWell(
            onTap: () => launch("https://www.youtube.com/watch?v=${widget.snapshot.data![index].key}"),
            child: Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Stack(
                    children: <Widget>[
                      // Placeholder for the trailer image
                      Container(
                        width: itemWidth,
                        height: 100,
                        color: Colors.black,
                      ),
                      Positioned(
                        top: 36,
                        left: (itemWidth - 36 - 16) / 2,
                        child: Icon(
                          Icons.play_circle_filled,
                          size: 36,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                // Display the trailer name
                Text(
                  widget.snapshot.data![index].name,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
