import 'dart:convert';

import 'package:flutflix/models/movie.dart';
import 'package:flutflix/onTapDetails.dart';
import 'package:flutflix/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> searchResult = [];
  final TextEditingController searchText = TextEditingController();

  Future<void> searchListFunction(String val) async {
    var searchUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$val';
    var searchResponse = await http.get(Uri.parse(searchUrl));
    if (searchResponse.statusCode == 200) {
      var tempData = jsonDecode(searchResponse.body);
      var searchJson = tempData['results'];

      setState(() {
        searchResult.clear();
        for (var item in searchJson) {
          if (item['id'] != null &&
              item['poster_path'] != null &&
              item['media_type'] != null) {
            searchResult.add({
              'id': item['id'],
              'poster_path': item['poster_path'],
              'media_type': item['media_type'],
              'popularity': item['popularity'],
              'overview': item['overview'],
              'releaseDate': item['media_type'] == 'movie' ? item['release_date'] : item['first_air_date'],
              'vote_average': item['vote_average'],
            });

            if (searchResult.length > 20) {
              searchResult.removeRange(20, searchResult.length);
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search for a movie",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                autofocus: false,
                controller: searchText,
                onChanged: (value) {
                  searchListFunction(value);
                },
                style: TextStyle(
                  color: Colors.white70,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        msg: "search cleared",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        searchText.clear();
                        searchResult.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.amber,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "eg : Avatar",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 5),
              if (searchResult.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: searchResult.map((item) {
                        
                          return Container(
                            
                            child: GestureDetector(
                              onTap: (){
                              if (item != null) {
                                Navigator.push(context, 
                                  MaterialPageRoute(
                                  builder: (context) => DetailScreen(movie: Movie(
                                    title: item['title'] ?? '',
                                    backdropPath: item['backdrop_path'] ?? '',
                                    originalTitle: item['original_title'] ?? '',
                                    overView: item['overview'] ?? '',
                                    posterPath: item['poster_path'] ?? '',
                                    releaseDate: item['first_air_date'] ?? '', // Use 'first_air_date' instead
                                    voteAverage: item['vote_average'] != null ? double.parse(item['vote_average'].toString()) : 0.0,
                                  )),
                                ),
                          
                          
                          
                                );
                              }
                            },
                          
                          
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(20, 20, 20, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 0.4,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${Constants.imagePath}${item['poster_path']}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item['media_type']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '${item['vote_average']}',
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Icon(
                                                Icons.people_outline_sharp,
                                                color: Colors.amber,
                                                size: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '${item['popularity']}',
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '${item['overview']}',
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
                            ),
                          );
                          
                      }).toList(),
                    ),
                  ),










                  
                ),
            ],
          ),
        ),
      ),
    );
  }
}
