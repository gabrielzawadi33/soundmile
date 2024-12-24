import 'package:flutter/material.dart';

import '../model/bottom_model.dart';
import '../model/home_slider_model.dart';
import '../model/introl_model.dart';
import '../model/popular_model.dart';
import '../model/release_model.dart';
import '../model/upcoming_model.dart';

class DataFile {
  static List<ModelIntro> introList = [
    ModelIntro("intro1.png", "Enjoy your", ' daily ', "Music"),
    ModelIntro("intro2.png", "Listen to ", "Cool Music", " with usefull value"),
    ModelIntro("intro3.png", "Listen your ", "favourite Music", " anywhere"),
    ModelIntro("intro4.png", "Welcome to ", "Mfariji", "")
  ];

static List<ModelBottom> bottomList = [
  // ModelBottom(Icons.home_outlined, Icons.home, "Home"),
  // ModelBottom(Icons.explore_outlined, Icons.explore, "Discover"),
  // ModelBottom(Icons.library_music_outlined, Icons.library_music, "My Library"),
  // ModelBottom(Icons.person_outline, Icons.person, "Profile")
];

  static List<ModelHomeSlider> homeSliderList = [
    ModelHomeSlider(
        "home_slider1.png", "#F9D7B5", "", "Get Entertained With music"),
    ModelHomeSlider("home_slider2.png", "#FFC2C2", "BORED?", "Get Entertained"),
    ModelHomeSlider(
        "home_slider1.png", "#F9D7B5", "", "Change your mood With Music"),
  ];

  static List<ModelPopular> popularList = [
    ModelPopular("Comasava", "comasava2.jpeg", "25 min"),
    ModelPopular("Unanchekesha", "unanchekesha.jpeg", "4 min"),
    ModelPopular("Shu", "shu.jpeg", "3 min")
  ];

  static List<ModelPopular> trendingList = [
    ModelPopular("Unanchekesha", "unanchekesha.jpeg", "30  min"),
    ModelPopular("mazoea", "mazoea.jpeg", "3 min"),
    ModelPopular("Tswala", "unanchekesha.jpeg", "20  min"),
    ModelPopular("Kwelanga", "unanchekesha.jpeg", "15  min"),
    ModelPopular("Carry me Home", "unanchekesha.jpeg", "15  min"),
  ];

  static List<ModelPopular> lifeStyleList = [
    ModelPopular("Jeje", "lifestyle1.png", "4 min"),
    ModelPopular("Mwana", "lifestyle2.png", "4 min"),
    ModelPopular("Yope Remix", "lifestyle3.png", "3 min"),
    ModelPopular("Njiwa", "lifestyle4.png", "3 min"),
    ModelPopular("Uno", "lifestyle5.png", "3 min"),
    ModelPopular("Chuchuma", "lifestyle6.png", "3 min"),
    ModelPopular("For You", "lifestyle7.png", "2min"),
    ModelPopular("Sukari", "lifestyle8.png", "4 min"),
    ModelPopular("Yahaya", "lifestyle9.png", "3 min"),
  ];

  static List<ModelUpcoming> upcomingList = [
    ModelUpcoming("upcoming1.png", "Suspect", "6 Aug,2022"),
    ModelUpcoming("upcoming2.png", "Unraveled", "10 Aug,2022"),
    ModelUpcoming("upcoming3.png", "Life on the line", "16 Aug,2022")
  ];

  static List<String> timeList = [
    "10-20 min",
    "30-60 min",
    "<1hr-30 min",
    ">1hr-30 min"
  ];

  static List<String> subjectList = [
    "Art",
    "Education",
    "Technology",
    "Comedy"
  ];

  static List<ModelRelease> releaseList = [
    ModelRelease("unanchekesha.jpeg", "BongoFleva"),
    ModelRelease("unanchekesha.jpeg", "Amapiano"),
    ModelRelease("unanchekesha.jpeg", "Gosple"),
    ModelRelease("unanchekesha.jpeg", "Hip-Hop"),
    ModelRelease("unanchekesha.jpeg", "Hip-Hop"),
    
  ];

  static List<String> recommendedList = [
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
  ];

  static List<String> trendingMusicList = [
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
    "unanchekesha.jpeg",
  ];

  static List<ModelRelease> libraryList = [
    ModelRelease("playlist.svg", "Playlists"),
    ModelRelease("heart_bold.svg", "Favourite Music"),
    ModelRelease("download_from_cloud.svg", "Downloads"),
  ];

  static List<ModelPopular> notificationList = [
    ModelPopular(
        "Sweet Bobby Add in Libraray ", "unanchekesha.jpeg", "15 Min ago"),
    ModelPopular(
        "Office Ladies Upcoming Podcast ", "unanchekesha.jpeg", "20 Min ago"),
    ModelPopular(
        "Mattis enim ut tellus elementum ", "unanchekesha.jpeg", "1 Day ago"),
    ModelPopular(
        "Iaculis nunc sed augue lacus ", "unanchekesha.jpeg", "1  Week ago"),
    ModelPopular("Nisi est sit amet facilisis magna", "unanchekesha.jpeg",
        "1  Week ago"),
    ModelPopular("Viverra justo nec ultrices dui sapi", "unanchekesha.jpeg",
        "1  Week ago")
  ];

  static List<ModelPopular> downloadList = [
    ModelPopular("unanchekesha.jpeg", "unanchekesha.jpeg", "30  min"),
    ModelPopular("unanchekesha.jpeg", "unanchekesha.jpeg", "30  min"),
    ModelPopular("unanchekesha.jpeg", "unanchekesha.jpeg", "30  min"),
    ModelPopular("unanchekesha.jpeg", "unanchekesha.jpeg", "30  min"),
    ModelPopular("unanchekesha.jpeg", "unanchekesha.jpeg", "30  min"),
    ModelPopular("unanchekesha.jpeg", "unanchekesha.jpeg", "30  min"),
  ];

  static List<ModelRelease> historyList = [
    ModelRelease("playlist.svg", "Playlists"),
    ModelRelease("", "Favourites"),
    ModelRelease("download_from_cloud.svg", "Downloads"),
    // ModelRelease("unanchekesha.jpeg", "Suspect")
  ];

  static List<ModelPopular> favouriteList = [
    ModelPopular("unanchekesha.jpeg", "Slow Burn", "20 min"),
    ModelPopular("unanchekesha.jpeg", "Office Ladies", "20 min"),
    ModelPopular("unanchekesha.jpeg", "Sweet Bobby", "20 min"),
    ModelPopular("unanchekesha.jpeg", "Suspect", "20 min")
  ];

  static List<ModelPopular> episodeList = [
    ModelPopular("song 1", "detail_image.png", "30  min"),
    ModelPopular("song 1", "detail_image.png", "35  min"),
    ModelPopular("song 1", "detail_image.png", "35  min"),
    ModelPopular("song 1", "detail_image.png", "35  min"),
    ModelPopular("song 1", "detail_image.png", "35  min"),
    ModelPopular("song 1", "detail_image.png", "35  min"),
    ModelPopular("song 1", "detail_image.png", "35  min"),
  ];

  static List<ModelPopular> playList = [
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "30  min"),
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "35  min"),
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "35  min"),
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "35  min"),
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "35  min"),
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "35  min"),
    ModelPopular("unanchekesha.jpeg", "detail_image.png", "35  min"),
  ];
  static List<ModelPopular> playListsList = [
    ModelPopular("playlist 1", "disc.svg", "16  Songs"),
    ModelPopular("playlist 2", "disc.svg", "27  Songs"),
    ModelPopular("playlist 3", "disc.svg", "40  Songs"),
    ModelPopular("playlist 4", "disc.svg", "1-  Songs"),
    ModelPopular("playlist 5", "disc.svg", "16  Songs"),
    ModelPopular("playlist 6", "disc.svg", "16  Songs"),
    ModelPopular("playlist 7", "disc.svg", "16  Songs"),
  ];
}
