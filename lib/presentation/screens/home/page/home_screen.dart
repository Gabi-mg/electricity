import 'package:electricity/domain/entities/value.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:electricity/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Precio de la luz por horas ')),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            'Elija lugar y día que desee consultar',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const CustomDropdownWidget(),
        const InputDatepickerWidget(),
        Divider(
          thickness: 2,
          color: Theme.of(context).primaryColor,
        ),
        const Expanded(
          child: _ListPrices(),
        ),
      ],
    );
  }
}

class _ListPrices extends StatelessWidget {
  const _ListPrices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<HomeBloc>(context);

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: blocProvider,
      builder: (context, state) {
        if (state is PricesLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 6.0,
            ),
          );
        } else if (state is PricesErrorState) {
          return const ErrWidget();
        } else {
          state = state as PricesLoadedState;
          List<Value> values = state.prices.included.attributes.values;
          return ListView.builder(
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              String value = values[index].valueKWh;
              String time = values[index].hour;

              final interval = blocProvider.getInterval(values, values[index]);

              Color color = values[index].getColor(interval);

              bool isValueMax = blocProvider.isValueMax(values[index].value);

              bool isValueMin = blocProvider.isValueMin(values[index].value);

              bool isValueNow = blocProvider.isValueNow(values[index]);

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
    );
  }
}
