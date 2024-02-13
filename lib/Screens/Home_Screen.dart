// ignore: file_names
import 'package:cinematix/api/api.dart';
import 'package:cinematix/widgets/TrendingSLider.dart';
import 'package:cinematix/widgets/movieSilder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinematix/models/movie.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upComingMovies;

  
  @override
  void initState(){
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    upComingMovies = Api().getUpComingMovies();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0 ,
        title: Image.asset(
            'assets/flutflix.png',
            fit: BoxFit.cover,
            height: 40,
            filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending  movies',
                style: GoogleFonts.aBeeZee(
                  fontSize: 25,                
                ) , 
              ),
              const SizedBox(height:30),
              SizedBox(
                child: FutureBuilder(
                  future: trendingMovies,
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    else if(snapshot.hasData){
                      final data = snapshot.data;
                      return  TrendingSlider( snapshot :snapshot);

                    }else{
                      return const Center(child:CircularProgressIndicator());
                    }
                  },
                )
              ),
              const SizedBox(height: 30),
              Text(
                'Top Rated Movies',
                style: GoogleFonts.aBeeZee(
                  fontSize: 25,
                ), 
              ),
              const SizedBox(height: 30),
              SizedBox(
                child: FutureBuilder(
                  future: topRatedMovies,
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    else if(snapshot.hasData){
                      final data = snapshot.data;
                      return  movieSlider( snapshot :snapshot);

                    }else{
                      return const Center(child:CircularProgressIndicator());
                    }
                  },
                )
              ),
              const SizedBox(height: 30),
              Text(
                'upcoming Movies',
                style: GoogleFonts.aBeeZee(
                  fontSize: 25,
                ), 
              ),
              SizedBox(
                child: FutureBuilder(
                  future: upComingMovies,
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    else if(snapshot.hasData){
                      final data = snapshot.data;
                      return  movieSlider( snapshot :snapshot);

                    }else{
                      return const Center(child:CircularProgressIndicator());
                    }
                  },
                )
              ),
             



            ],
          ),
        ),
      ),
    );
  }
}




