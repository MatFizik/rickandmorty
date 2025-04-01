import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/common/theme/bloc/cubit/theme_cubit.dart';
import 'package:rickandmorty/common/widgets/tiles/custom_mini_tile_widget.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({super.key});

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        context.watch<ThemeCubit>().state.brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 50,
          child: CustomMiniTileWidget(
            title: 'Тема оформления',
            subtitle: isDarkTheme ? 'Темная тема' : 'Светлая тема',
            onTap: () {
              context.read<ThemeCubit>().toggleTheme(isDarkTheme);
            },
          ),
        ),
      ),
    );
  }
}
