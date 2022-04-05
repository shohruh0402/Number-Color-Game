import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbergame/cubit/home_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List list = [];
  List numList = [0, 1, 2, 3];
  final _rng = Random();
  Color number = Colors.indigo;
  List<MaterialColor> color = [
    Colors.pink,
    Colors.blue,
    Colors.brown,
    Colors.cyan,
  ];
  List<MaterialColor> colorNumber = [
    Colors.indigo,
    Colors.orange,
    Colors.green,
    Colors.yellow,
  ];
  int _list = 0;

  @override
  void initState() {
    super.initState();
    _randomize();
  }

  void _randomize() {
    list = [
      for (var i = 0; i < 4; i++)
        Alignment(
          _rng.nextDouble() * 2 - 1,
          _rng.nextDouble() * 2 - 1,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountCubit(),
      child: BlocConsumer<CountCubit, CountState>(
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (var i = 0; i < 4; i++)
                      GestureDetector(
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          alignment: list[i],
                          child: CircleAvatar(
                            backgroundColor: color[i],
                            radius: 33,
                            child: Text(
                              i.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: colorNumber[numList[i]]),
                            ),
                          ),
                        ),
                        onTap: context.read<CountCubit>().start
                            ? null
                            : () {
                                setState(() {
                                  if (number == colorNumber[numList[i]]) {
                                    setState(() {
                                      context.read<CountCubit>().score += 1;
                                    });
                                  } else {
                                    setState(() {
                                      context.read<CountCubit>().score -= 1;
                                    });
                                  }
                                  _list = _rng.nextInt(4);
                                  number = colorNumber[_list];

                                  list = [
                                    for (var i = 0; i < 4; i++)
                                      Alignment(
                                        _rng.nextDouble() * 2 - 1,
                                        _rng.nextDouble() * 2 - 1,
                                      ),
                                  ];
                                  numList.shuffle();
                                });
                              },
                      ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Number Color:',
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                              CircleAvatar(
                                backgroundColor: number,
                              )
                            ],
                          ),
                          Text(
                            'Score: ${context.read<CountCubit>().score}',
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Time: ${context.watch<CountCubit>().count}',
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          Visibility(
                            visible: context.read<CountCubit>().start,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CountCubit>().startTimer();
                                context.read<CountCubit>().score = 0;
                              },
                              child: const Text('Start'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {}),
    );
  }
}
