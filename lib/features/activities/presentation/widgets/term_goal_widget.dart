import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/actual_goals_manager.dart';
/*
class TermGoalTileWidget extends StatelessWidget {
  final TermGoal goal;
  final goalIndexInList;
  final void Function()? deleteActualMeth;
  //работу с этим методом надо будет прописать
  //извне закидываеть будем функции из модели
  //конкретного экрана - model.delete
  //потому что сервис с виджетом не 
  //должен пересекаться

  const TermGoalTileWidget(
      {super.key,
      required this.goal,
      required this.goalIndexInList,
      required this.deleteActualMeth});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.text,
                        softWrap: false,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                text: "Срок до: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text:
                                    "${goal.lastDate?.day}/${goal.lastDate?.month}/${goal.lastDate?.year}"),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Статус: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Не выполнена"),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Актуальность: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "Активная цель"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          deleteActualMeth;
                        },
                        child: const Text(
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Завершить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
*/