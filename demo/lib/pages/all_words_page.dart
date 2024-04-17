import 'package:demo/models/english_today.dart';
import 'package:demo/values/app_assets.dart';
import 'package:demo/values/app_colors.dart';
import 'package:demo/values/app_styles.dart';
import 'package:flutter/material.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToDay> words;
  const AllWordsPage({Key? key, required this.words});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(AppAssets.leftArrow),
          ),
        ),
        body: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: (index % 2) == 0
                        ? AppColors.primaryColor
                        : AppColors.secondColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    words[index].noun!,
                    style: (index % 2) == 0
                        ? AppStyles.h4
                        : AppStyles.h4.copyWith(color: AppColors.textColor),
                  ),
                  subtitle: Text(words[index].quote ??
                      '"Think of all the beauty still left around you and be happy."'),
                  leading: Icon(
                    Icons.favorite,
                    color: words[index].isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              );
            }));
  }
}
