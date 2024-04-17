import 'package:demo/values/app_assets.dart';
import 'package:demo/values/app_colors.dart';
import 'package:demo/values/app_styles.dart';
import 'package:demo/values/share_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  void initState() {
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  double sliderValue = 5;
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondColor,
        title: Text(
          'Your control',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt(ShareKeys.counter, sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            Text('How mush a number word at once',
                style: AppStyles.h4
                    .copyWith(color: AppColors.textColor, fontSize: 18)),
            const Spacer(),
            Text('${sliderValue.toInt()}',
                style: AppStyles.h1.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 150,
                    fontWeight: FontWeight.bold)),
            Slider(
                value: sliderValue,
                min: 5,
                max: 100,
                divisions: 95,
                activeColor: AppColors.primaryColor,
                inactiveColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.centerLeft,
              child: Text(
                'Slide to set',
                style: AppStyles.h5.copyWith(color: AppColors.textColor),
              ),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
