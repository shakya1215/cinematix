import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../newDetail.dart';
import 'constants.dart';

class TrendingSlider extends StatelessWidget {

  const TrendingSlider({
    super.key, required this.snapshot,
  });
  
  final AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: snapshot.data!.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.55,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,//enlarging the center page
          pageSnapping: true,
          autoPlayAnimationDuration: const Duration(
            seconds: 2
          )
        
        ),
        itemBuilder:(context,itemIndex ,pageViewIndex){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) =>   DetailScreen1(
                    movie: snapshot.data[itemIndex],
                  ),
                ),
              
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                width: 200, // Set width to fill available space
                child : Image.network(
                  filterQuality: FilterQuality.high,
                  fit:BoxFit.cover,
                  '${Constants.imagePath}${snapshot.data[itemIndex].posterPath}'
                ),
              ),
            ),
          );
        }
         
      ),
    );
  }
}