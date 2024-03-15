import 'package:flutter/material.dart'; // Importing necessary packages.
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/movie.dart'; // Importing custom movie model.
import 'newDetail.dart'; // Importing DetailScreen1.
import 'widgets/constants.dart'; // Importing constants.

// A stateful widget representing the search page.
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

// The state class for the SearchPage widget.
class SearchPageState extends State<SearchPage> {
  late List<Movie> searchResult = []; // List to store search results.
  final TextEditingController searchText = TextEditingController(); // Controller for the search text field.
  var val1 = ""; // Variable to store the search query.
  var mediaType = "all"; // Default media type for search.

  // Function to fetch search results from API.
  Future<List<Movie>> searchListFunction(String val, String mediaType) async {
    // Constructing the search URL based on the media type.
    var searchUrl = mediaType == 'all'
        ? 'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$val'
        : 'https://api.themoviedb.org/3/search/$mediaType?api_key=${Constants.apiKey}&query=$val';

    // Sending HTTP GET request to fetch search results.
    final response = await http.get(Uri.parse(searchUrl));

    // Handling the response.
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List; // Decoding the response JSON.
      List<Movie> searchResults = []; // List to store decoded search results.

      // Iterating over each item in the decoded data.
      decodedData.forEach((itemJson) {
        if (itemJson['poster_path'] != null) {
          searchResults.add(Movie.fromJson(itemJson)); // Adding movie to search results if it has a poster.
        }
        if (mediaType == 'person' || mediaType == 'all' && itemJson['known_for'] != null) {
          // Adding known movies/TV shows of the person to search results.
          var knownFor = (itemJson['known_for'] as List)
              .map((knownForJson) => Movie.fromJson(knownForJson))
              .toList();
          searchResults.addAll(knownFor);
        }
      });
      return searchResults; // Returning the search results.
    } else {
      throw Exception("Something happened"); // Throw an exception if there's an error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchText,
                onChanged: (value) {
                  setState(() {
                    val1 = value;
                  });
                  // Trigger search function when user enters text
                  searchListFunction(val1, mediaType).then((result) {
                    setState(() {
                      searchResult = result;
                    });
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        msg: "Search Cleared",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        searchText.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                        searchResult.clear();
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.amber.withOpacity(0.6),
                    ),
                  ),
                  prefixIcon: PopupMenuButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.amber,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: Text('All'),
                        value: 'all',
                      ),
                      PopupMenuItem(
                        child: Text('By Movie'),
                        value: 'movie',
                      ),
                      PopupMenuItem(
                        child: Text('By TV Series'),
                        value: 'tv',
                      ),
                      PopupMenuItem(
                        child: Text('By Person'),
                        value: 'person',
                      ),
                    ],
                    onSelected: (value) {
                      setState(() {
                        val1 = searchText.text;
                        searchResult.clear();
                      });
                      mediaType = value; // Update the media type for search.
                      searchListFunction(val1, mediaType).then((result) {
                        setState(() {
                          searchResult = result;
                        });
                      });
                    },
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            if (val1.isNotEmpty)
              Expanded(
                child: searchResult.isEmpty
                    ? Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResult.length,
                        itemBuilder: (context, index) {
                          var item = searchResult[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen1(movie: item),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(20, 20, 20, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      '${Constants.imagePath}${item.posterPath}',
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        // Display alternative image or placeholder when the original image fails to load
                                        return Image.asset(
                                          'assets/alternative_image.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 20),
                                            SizedBox(width: 5),
                                            Text(
                                              '${item.voteAverage}',
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Icon(Icons.people_outline_sharp, color: Colors.amber, size: 20),
                                            SizedBox(width: 5),
                                            Text(
                                              '${item.popularity}',
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          item.overView,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
