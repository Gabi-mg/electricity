import 'package:electricity/domain/entities/interval_enum.dart';
import 'package:electricity/presentation/screens/home/bloc/home_bloc.dart';
import 'package:electricity/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luz')),
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
        const CustomDropdownWidget(),
        Divider(
          thickness: 2,
          color: Theme.of(context).primaryColor,
        ),
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
        if (state.prices != null) {
          return ListView.builder(
            itemCount: state.prices!.included.attributes.values.length,
            itemBuilder: (BuildContext context, int index) {
              String value =
                  state.prices!.included.attributes.values[index].valueKWh;
              String time =
                  state.prices!.included.attributes.values[index].hour;

              // final interval = blocProvider.getInterval(
              //     state.prices!.included.attributes.values,
              //     state.prices!.included.attributes.values[index]);
              final interval = IntervalEnum.interval1;

              Color color = state.prices!.included.attributes.values[index]
                  .getColor(interval);

              // bool isValueMax = blocProvider.isValueMax(
              //     state.prices!.included.attributes.values[index].value);
              //
              // bool isValueMin = blocProvider.isValueMin(
              //     state.prices!.included.attributes.values[index].value);
              //
              // bool isValueNow = blocProvider
              //     .isValueNow(state.prices!.included.attributes.values[index]);

              return PriceWidget(
                value: value,
                time: time,
                color: color,
                // isHighestPrice: isValueMax,
                // isLowestPrice: isValueMin,
                // isCurrentValue: isValueNow,
              );
            },
          );
        } else if (state.isError) {
          return const ErrWidget();
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 6.0,
            ),
          );
        }
      },
    );
  }
}
