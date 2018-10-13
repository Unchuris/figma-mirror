import 'package:figma_mirror/data/datasource/remote/figma_api.dart';
import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/data/repositories/figma_repository.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:http/http.dart';

enum Flavor {
  LOCAL,
  NETWORK
}

class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  ScreenRepository get screenRepository {
    return new FigmaRepository(FigmaAPI(Client()), AuthRepository());
  }

}
