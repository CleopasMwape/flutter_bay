import 'package:flutter/material.dart';
import 'package:flutter_bay/ui/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (_) => ThemeBloc(),
    //   child: const ThemeView(),
    // );

    return const ThemeView();
  }
}

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Switch(
          value: state.isDarkMode,
          onChanged: (_) {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
        );
      },
    );
  }
}
