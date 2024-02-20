import 'package:ava_hesab/core/network/network.dart';
import 'package:ava_hesab/feature/login/data/source/login_data_source.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future initServiceLocator() async {
  provideProviderModule();
  provideNetworkModule();
  provideNetworkDataSourceModule();
}

void provideProviderModule() {}

void provideNetworkModule() {
  getIt.registerSingleton<NetworkClient>(NetworkClient());
}

void provideNetworkDataSourceModule() {
  getIt.registerLazySingleton<ILoginDataSource>(() => LoginDataSource(networkClient: getIt()));
}