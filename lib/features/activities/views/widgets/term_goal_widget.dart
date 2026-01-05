import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';

class TermGoalTileWidget extends StatelessWidget {
  final TermGoal goal;

  const TermGoalTileWidget({
    super.key,
    required this.goal,
  });

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
              borderRadius: BorderRadius.circular(10),
            ),
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
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Срок до: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            TextSpan(
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                text:
                                    "${goal.lastDate?.day}/${goal.lastDate?.month}/${goal.lastDate?.year}"),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Статус: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                style: TextStyle(fontSize: 20),
                                text: goal.isComplete
                                    ? "Цель выполнена"
                                    : "Цель не выполнена"),
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
                          TermGoalsService().deleteTermFromBoxById(goal.id);
                        },
                        child: const Text(
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: goal.isComplete
                            ? null
                            : () {
                                goal.isComplete = true;
                                TermGoalsService()
                                    .deleteTermFromActualList(goal.id);
                              },
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
