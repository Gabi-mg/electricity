import 'package:electricity/common/utils/utils.dart';
import 'package:electricity/domain/entities/entities.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:electricity/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precio de la luz por horas '),
        actions: [
          IconButton(
            onPressed: () {
              displayDialogSearch(context);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: const _Body(),
    );
  }
}

void displayDialogSearch(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        title: const Text('Elija criterios de búsqueda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CustomDropdownWidget(),
            InputDatepickerWidget(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final priceBlocProvider = BlocProvider.of<HomeBloc>(context);
              priceBlocProvider.add(const LoadingPriceEvent());
              Navigator.pop(context);
            },
            child: Text(
              'Aceptar',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceBlocProvider = BlocProvider.of<HomeBloc>(context);

    return RefreshIndicator(
      onRefresh: () {
        priceBlocProvider.add(const LoadingPriceEvent());
        return Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const _PriceNow(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<Value>(
                    stream: priceBlocProvider.outValueMin,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Value value = snapshot.data!;
                        return ValuePriceWidget(
                          title: 'Precio más bajo',
                          price: value.valueKWh,
                          hour: value.hour,
                          color: Colors.green,
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
                  ),
                  StreamBuilder<double>(
                    stream: priceBlocProvider.outAverage,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        double value = snapshot.data!;
                        return ValuePriceWidget(
                          title: 'Precio medio',
                          price: value.toStringAsFixed(5),
                          color: Colors.orange,
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
                  ),
                  StreamBuilder<Value>(
                    stream: priceBlocProvider.outValueMax,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Value value = snapshot.data!;
                        return ValuePriceWidget(
                          title: 'Precio más alto',
                          price: value.valueKWh,
                          hour: value.hour,
                          color: Colors.red,
                        );
                      } else {
                        return const SizedBox(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const _DetailPrices(),
              const SizedBox(height: 10),
              const Text(
                'Fuente: Red Eléctrica de España.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailPrices extends StatelessWidget {
  const _DetailPrices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceBlocProvider = BlocProvider.of<HomeBloc>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is PricesLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is PricesErrorState) {
            return const ErrWidget();
          } else {
            state = state as PricesLoadedState;
            List<Value> values = state.prices.included.attributes.values;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: values.length,
              itemBuilder: (BuildContext context, int index) {
                String value = values[index].valueKWh;
                String time = values[index].hour;

                final interval =
                    priceBlocProvider.getInterval(values, values[index]);

                Color color = values[index].getColor(interval);

                bool isValueMax =
                    priceBlocProvider.isValueMax(values[index].value);

                bool isValueMin =
                    priceBlocProvider.isValueMin(values[index].value);

                bool isValueNow = priceBlocProvider.isValueNow(values[index]);

                return PriceWidget(
                  value: value,
                  time: time,
                  color: color,
                  isHighestPrice: isValueMax,
                  isLowestPrice: isValueMin,
                  isCurrentValue: isValueNow,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _PriceNow extends StatelessWidget {
  const _PriceNow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceBlocProvider = BlocProvider.of<HomeBloc>(context);
    return StreamBuilder<Value>(
      stream: priceBlocProvider.outValueCurrent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Value value = snapshot.data!;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 150,
            child: Column(
              children: [
                const Text(
                  'Precio ahora',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                const Divider(
                  indent: 50,
                  endIndent: 50,
                  color: Colors.grey,
                  thickness: 2,
                ),
                Text(
                  '${value.valueKWh}€',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  priceBlocProvider.geoId!.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  Utils.formatDate(priceBlocProvider.date),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
