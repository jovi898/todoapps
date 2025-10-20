import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/constants/app_colors.dart';
import 'package:todoapp/core/constants/app_text_styles.dart';
import 'package:todoapp/core/constants/assets.dart';
import 'package:todoapp/core/constants/locale_keys.g.dart';
import 'package:todoapp/presentation/screens/blocs/background/background_cubit.dart';

class DrawerTasks extends StatelessWidget {
  const DrawerTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.blackWithOpacity,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(radius: 60, backgroundImage: AssetImage(AppAssets.avatar)),
                  Text(LocaleKeys.NAME_USER.tr(), style: AppTextStyles.boldTextWhite),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.white),
              title: Text(LocaleKeys.HOME.tr(), style: AppTextStyles.middleTextWhite),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.white),
              title: Text(
                LocaleKeys.SETTINGS.tr(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.wallpaper, color: AppColors.white),
              title: Text(LocaleKeys.WALLPAPER.tr(), style: AppTextStyles.middleTextWhite),
              onTap: context.watch<BackgroundCubit>().pickBackgroundImage,
            ),
          ],
        ),
      ),
    );
  }
}
