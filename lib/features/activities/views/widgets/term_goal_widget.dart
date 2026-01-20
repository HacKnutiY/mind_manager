import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/data/services/term_goal_service.dart';
import 'package:mind_manager/features/activities/models/term_goal_tile_model.dart';

//ful потому что нужно сохранять
//состояние isComplete
class TermGoalTileWidget extends StatefulWidget {
  final TermGoal goal;

  const TermGoalTileWidget({
    super.key,
    required this.goal,
  });

  @override
  State<TermGoalTileWidget> createState() => _TermGoalTileWidgetState();
}

class _TermGoalTileWidgetState extends State<TermGoalTileWidget> {
  late TermGoalTileModel model;
  late TermGoal termGoal;
  @override
  didChangeDependencies() {
    termGoal = widget.goal;
    model = TermGoalTileModel(termGoal: termGoal);
    super.didChangeDependencies();
  }

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
                        widget.goal.text,
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
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                text: model.lastDate),
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
                                style: const TextStyle(fontSize: 20),
                                text: termGoal.isComplete
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
                          model.deleteTermGoal(termGoal.id);
                        },
                        child: const Text(
                          "Удалить",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: termGoal.isComplete
                            ? null
                            : () {
                                setState(() {
                                  termGoal.isComplete = true;
                                  model.finishTermGoal(termGoal.id);
                                });
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
