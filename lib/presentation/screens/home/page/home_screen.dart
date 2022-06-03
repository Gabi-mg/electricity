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
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is PricesLoadingState) {
          return const CustomLoading();
        } else if (state is PricesErrorState) {
          return const CustomScaffold(body: _Body(values: null));
        } else {
          state = state as PricesLoadedState;
          List<Value> values = state.prices.included.attributes.values;
          return CustomScaffold(body: _Body(values: values));
        }
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, this.values}) : super(key: key);

  final List<Value>? values;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final priceBlocProvider = BlocProvider.of<HomeBloc>(
          context,
          listen: false,
        );
        priceBlocProvider.add(const LoadingPriceEvent());
        return Future.delayed(const Duration(seconds: 1));
      },
      child: values == null ? const CustomError() : _Details(values: values!),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({Key? key, required this.values}) : super(key: key);

  final List<Value> values;

  @override
  Widget build(BuildContext context) {
    final priceBlocProvider = BlocProvider.of<HomeBloc>(context);
    final valueMax = priceBlocProvider.maxValue;
    final valueMin = priceBlocProvider.minValue;
    final valueAverage = priceBlocProvider.averageValue;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const _PriceNow(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HourSummary(
                  title: 'Precio más bajo',
                  price: valueMin.valueKWh,
                  hour: valueMin.hour,
                  color: Colors.green,
                ),
                HourSummary(
                  title: 'Precio medio',
                  price: valueAverage.toStringAsFixed(5),
                  color: Colors.orange,
                ),
                HourSummary(
                  title: 'Precio más alto',
                  price: valueMax.valueKWh,
                  hour: valueMax.hour,
                  color: Colors.red,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: values.length,
                itemBuilder: (BuildContext context, int index) {
                  String value = values[index].valueKWh;
                  String time = values[index].hour;

                  final interval =
                      priceBlocProvider.getInterval(values, values[index]);

                  Color color = values[index].getColor(interval);

                  bool isValueMax = priceBlocProvider.isValueMax(values[index]);

                  bool isValueMin = priceBlocProvider.isValueMin(values[index]);

                  bool isValueNow = priceBlocProvider.isValueNow(values[index]);

                  return HourDetail(
                    value: value,
                    time: time,
                    color: color,
                    isHighestPrice: isValueMax,
                    isLowestPrice: isValueMin,
                    isCurrentValue: isValueNow,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceNow extends StatelessWidget {
  const _PriceNow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceBlocProvider = BlocProvider.of<HomeBloc>(context);
    final valueCurrent = priceBlocProvider.currentValue;
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          if (valueCurrent != null)
            const Text(
              'Precio ahora',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          if (valueCurrent != null)
            const Divider(
              indent: 50,
              endIndent: 50,
              color: Colors.grey,
              thickness: 2,
            ),
          if (valueCurrent != null)
            Text(
              '${valueCurrent.valueKWh}€',
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
  }
}
