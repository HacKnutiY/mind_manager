import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/features/activities/models/term_goal_tile_model.dart';
import 'package:provider/provider.dart';

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
  late final TermGoal termGoal;
  @override
  didChangeDependencies() {
    termGoal = widget.goal;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: 350,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.goal.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            text: context
                                .read<TermGoalTileModel>()
                                .getLastDate(termGoal.id),
                          ),
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            text:
                                " (осталось ${context.read<TermGoalTileModel>().geLeftDays(termGoal.id)} дней)",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Статус: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                              style: const TextStyle(fontSize: 18),
                              text: termGoal.isComplete
                                  ? "Цель выполнена"
                                  : "Цель не выполнена"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<TermGoalTileModel>()
                            .deleteTerm(termGoal.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Удалить",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: termGoal.isComplete
                          ? null
                          : () {
                              setState(() {
                                context
                                    .read<TermGoalTileModel>()
                                    .completeTerm(termGoal.id);
                              });
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Завершить",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
