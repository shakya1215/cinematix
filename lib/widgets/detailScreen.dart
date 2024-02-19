import 'package:flutflix/colors.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/widgets/backButton.dart';
import 'package:flutflix/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class detailScreen extends StatelessWidget {
  const detailScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: const backButton() ,
           backgroundColor: Colours.scaffoldBgColor,
           expandedHeight: 500,  
           pinned: true,
           floating: true,
           flexibleSpace: FlexibleSpaceBar(
            title: Text(
              movie.title,
              style: GoogleFonts.belleza(
                fontSize: 18,
                fontWeight: FontWeight.w600,

              ),

            ),
            background: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),

              ),
              child: Image.network('${Constants.imagePath}${movie.posterPath}',
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              ),
            ),

           ),


          ),
           SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Overview',    
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,

                    ),
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    movie.overView,
                    style: GoogleFonts.cabin(
                      fontSize:20 ,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                   SizedBox(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration:BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)
                          ) ,
                          child: Row(
                            children: [
                              Text(
                                'Released date: ',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                movie.releaseDate,
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                

                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration:BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Rating',
                                style: GoogleFonts.cabin(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                
                              ),
                              Text(
                                '${movie.voteAverage.toStringAsFixed(1)}/10'
                              ),
                            ],
                          ),

                        )
                      ],
                    ) ,
                  ),
                ],
              ),

            ),
          ),
        ],

      ),
    );
  }
}

