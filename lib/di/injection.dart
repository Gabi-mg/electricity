import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:electricity/data/datasources/local_datasource.dart';
import 'package:electricity/data/datasources/remote_datasource.dart';
import 'package:electricity/data/network/rest_client_service.dart';
import 'package:electricity/data/repositories/repository_impl.dart';
import 'package:electricity/domain/repositories/repository.dart';
import 'package:electricity/domain/usecases/place_usecase.dart';
import 'package:electricity/domain/usecases/price_usecase.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDi() async {
  bool trustSelfSigned = true;
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = IOClient(httpClient);

  final client = ChopperClient(
    interceptors: [
      CurlInterceptor(),
      HttpLoggingInterceptor(),
    ],
    client: ioClient,
  );
  serviceLocator.registerLazySingleton(() => RestClientService.create(client));

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  //datasources
  serviceLocator.registerLazySingleton<RemoteDatasource>(
    () => RemoteDatasourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<LocalDatasource>(
    () => LocalDatasourceImpl(serviceLocator()),
  );

  //repositories
  serviceLocator.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDatasource: serviceLocator(),
    ),
  );

  //usecases
  serviceLocator.registerLazySingleton(() => PriceUsecase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => PlaceUsecase(serviceLocator()));

  //Blocs
  serviceLocator.registerFactory(
    () => HomeBloc(
      priceUsecase: serviceLocator(),
      placeUsecase: serviceLocator(),
    ),
  );
}
