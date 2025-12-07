import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'init',
  preferRelativeImports: false,
  asExtension: true,
)
void configureDependencies() {
  // This will be replaced by generated code
  // Run: flutter pub run build_runner build
  getIt.init();
}
