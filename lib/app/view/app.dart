import 'package:flutter/material.dart';
import 'package:flutter_bay/data/repositories/product_repository.dart';
import 'package:flutter_bay/data/repositories/theme_repository.dart';
import 'package:flutter_bay/l10n/l10n.dart';
import 'package:flutter_bay/ui/product_details/bloc/product_details_bloc.dart';
import 'package:flutter_bay/ui/products/bloc/products_bloc.dart';
import 'package:flutter_bay/ui/products/view/products_page.dart';
import 'package:flutter_bay/ui/theme/bloc/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required this.productRepository,
    required this.themeRepository,

    super.key,
  });

  final ProductRepository productRepository;
  final ThemeRepository themeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: productRepository),
        RepositoryProvider.value(value: themeRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(
              themeRepository,
            ),
          ),
          BlocProvider(
            create: (context) => ProductsBloc(
              repository: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                ProductDetailsBloc(repository: productRepository),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.isDarkMode ? ThemeData.dark() : ThemeData.light(),

              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const ProductsPage(),
            );
          },
        ),
      ),
    );
  }
}
