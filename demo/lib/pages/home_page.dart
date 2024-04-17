// ignore_for_file: dead_code

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo/models/english_today.dart';
import 'package:demo/packages/quote/qoute_model.dart';
import 'package:demo/packages/quote/quote.dart';
import 'package:demo/pages/all_words_page.dart';
import 'package:demo/pages/control_page.dart';
import 'package:demo/values/app_assets.dart';
import 'package:demo/values/app_colors.dart';
import 'package:demo/values/app_styles.dart';
import 'package:demo/values/share_keys.dart';
import 'package:demo/widgets/appButton.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToDay> words = [];

  String quote = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];
    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int length = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: length, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToDay getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToDay(noun: noun, quote: quote?.content, id: quote?.id);
  }

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToDay();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scafoldKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        title: Text(
          'English today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        backgroundColor: AppColors.secondColor,
        leading: InkWell(
          onTap: () {
            _scafoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: size.height * 1 / 10,
              alignment: Alignment.centerLeft,
              child: Text(
                '"$quote"',
                style: AppStyles.h5
                    .copyWith(fontSize: 12, color: AppColors.textColor),
              ),
            ),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: words.length > 5 ? 6 : words.length,
                itemBuilder: (context, index) {
                  String firstLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  firstLetter = firstLetter.substring(0, 1);
                  String leftLetter =
                      words[index].noun != null ? words[index].noun! : '';
                  leftLetter = leftLetter.substring(1, leftLetter.length);
                  String quoteDefault =
                      'Think of all the beauty still left around you and be happy.';
                  String quote = words[index].quote != null
                      ? words[index].quote!
                      : quoteDefault;
                  return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        color: AppColors.primaryColor,
                        elevation: 4,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              words[index].isFavorite =
                                  !words[index].isFavorite;
                            });
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: index >= 5
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AllWordsPage(words: words)));
                                    },
                                    child: Center(
                                      child: Text(
                                        'Show more...',
                                        style: AppStyles.h3.copyWith(
                                            shadows: const [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6)
                                            ]),
                                      ),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LikeButton(
                                        onTap: (bool isLiked) async {
                                          setState(() {
                                            words[index].isFavorite =
                                                !words[index].isFavorite;
                                          });
                                          return words[index].isFavorite;
                                        },
                                        isLiked: words[index].isFavorite,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        size: 42,
                                        circleColor: const CircleColor(
                                            start: Color(0xff00ddff),
                                            end: Color(0xff0099cc)),
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Color(0xff33b5e5),
                                          dotSecondaryColor: Color(0xff0099cc),
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return ImageIcon(
                                            AssetImage(AppAssets.heart),
                                            color: words[index].isFavorite
                                                ? Colors.red
                                                : Colors.white,
                                          );
                                        },
                                      ),

                                      // Container(
                                      //     alignment: Alignment.centerRight,
                                      //     child: Image.asset(
                                      //       AppAssets.heart,
                                      //       color: words[index].isFavorite
                                      //           ? Colors.red
                                      //           : Colors.white,
                                      //     )),
                                      RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                              text: firstLetter,
                                              style: TextStyle(
                                                  fontFamily: FontFamily.sen,
                                                  fontSize: 89,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: const [
                                                    BoxShadow(
                                                        color: Colors.black38,
                                                        offset: Offset(3, 6),
                                                        blurRadius: 6)
                                                  ]),
                                              children: [
                                                TextSpan(
                                                    text: leftLetter,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontFamily.sen,
                                                        fontSize: 56,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        shadows: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black38,
                                                              offset:
                                                                  Offset(3, 6),
                                                              blurRadius: 6)
                                                        ]))
                                              ])),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: AutoSizeText(
                                          maxFontSize: 26,
                                          '"$quote"',
                                          style: AppStyles.h4.copyWith(
                                              letterSpacing: 1,
                                              color: AppColors.textColor),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                      ));
                },
              ),
            ),
            //indicator

            _currentIndex >= 5
                ? buildShowMore()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: size.height * 1 / 13,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return buildIndicator(index == _currentIndex, size);
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToDay();
            _currentIndex = 0;
            _pageController.jumpToPage(0);
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lighBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(label: 'Favorite', onTap: () {}),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Your control',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ControlPage()));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: isActive ? size.width * 1 / 5 : 30,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        borderRadius: BorderRadius.circular(24),
        elevation: 4,
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AllWordsPage(words: this.words)),
            );
          },
          splashColor: Colors.black38,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'Show more',
              style: AppStyles.h5,
            ),
          ),
        ),
      ),
    );
  }
}
