import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:electricity/data/datasources/price_datasource.dart';
import 'package:electricity/data/network/rest_client_service.dart';
import 'package:electricity/data/repositories/price_repository_impl.dart';
import 'package:electricity/domain/repositories/price_repository.dart';
import 'package:electricity/domain/usecases/price_usecase.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';

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

  //datasources
  serviceLocator.registerLazySingleton<PriceDataSource>(
    () => PriceDataSourceImpl(serviceLocator()),
  );

  //repositories
  serviceLocator.registerLazySingleton<PriceRepository>(
    () => PriceRepositoryImpl(serviceLocator()),
  );

  //usecases
  serviceLocator.registerLazySingleton(() => PriceUsecase(serviceLocator()));

  //Blocs
  serviceLocator
      .registerFactory(() => HomeBloc(serviceLocator()) //..add(LoadingEvent()),
          );
}
