import 'package:demo/values/app_assets.dart';
import 'package:demo/values/app_colors.dart';
import 'package:demo/values/app_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        title: Text(
          'English today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        backgroundColor: AppColors.secondColor,
        leading: InkWell(
          onTap: () {},
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
                '"It is amazing how complete is the delusion that beauty is goodness"',
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(3, 6),
                                blurRadius: 6)
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              child: Image.asset(AppAssets.heart)),
                          RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: 'B',
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
                                        text: 'eautiful',
                                        style: TextStyle(
                                            fontFamily: FontFamily.sen,
                                            fontSize: 56,
                                            fontWeight: FontWeight.bold,
                                            shadows: const [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6)
                                            ]))
                                  ])),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Text(
                              '"Think of all the beauty still left around you and be happy."',
                              style: AppStyles.h4.copyWith(
                                  letterSpacing: 1, color: AppColors.textColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            //indicator
            Padding(
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
        onPressed: () {},
        child: Image.asset(AppAssets.exchange),
      ),
    );
  }
}

Widget buildIndicator(bool isActive, Size size) {
  return Container(
    height: 8,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    width: isActive ? size.width * 1 / 5 : 30,
    decoration: BoxDecoration(
        color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
        ]),
  );
}
