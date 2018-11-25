import 'package:figma_mirror/data/datasource/remote/figma_api.dart';
import 'package:figma_mirror/data/datasource/remote/figma_base_api.dart';
import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/data/repositories/figma_repository.dart';
import 'package:figma_mirror/data/repositories/figma_repository_api.dart';
import 'package:figma_mirror/data/repositories/local_repository.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:http/http.dart';

enum Flavor {
  LOCAL,
  NETWORK
}

class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  ScreenRepository get screenRepository {
    if (_flavor == Flavor.NETWORK) {
      return FigmaRepositoryApi(FigmaAPI(Client()), AuthRepository());
    } else {
      return LocalRepository();
    }
  }

  HomeRepository get homeRepository {
    return FigmaRepository(FigmaBaseApi(Client()));
  }
}
