import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/data/entities/task.dart';
import 'package:mind_manager/features/sprint/models/sprint_tile_model.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_goal_widget.dart';

class SprintTileWidget extends StatefulWidget {
  final Sprint sprint;
  const SprintTileWidget({
    super.key,
    required this.sprint,
  });

  @override
  State<SprintTileWidget> createState() => _SprintTileWidgetState();
}

class _SprintTileWidgetState extends State<SprintTileWidget> {
  @override
  Widget build(BuildContext context) {
    SprintTileModel? model = SprintTileModel(
      sprintKey: widget.sprint.key,
      startDate: widget.sprint.startDate,
      endDate: widget.sprint.endDate,
    );

    return GestureDetector(
      onLongPress: () => model.toSprintScreen(context, widget.sprint.key),
      child: Card(
        child: ExpansionTile(
          leading: const FlutterLogo(size: 72.0),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.sprint.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  text:
                      " [${model.formattedStartDate} - ${model.formattedEndDate}]",
                ),
              ],
            ),
          ),
          subtitle: widget.sprint.isActive
              ? const Text(
                  'Активный спринт',
                  style: TextStyle(color: Colors.green),
                )
              : const Text(
                  'Завершенный спринт',
                  style: TextStyle(color: Colors.red),
                ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          children: <Widget>[
            ValueListenableBuilder<Box<Task>>(
              builder: (BuildContext context, Box<Task> a, Widget? child) {
                List<Task> goals =
                    model.getActualSprintGoals(widget.sprint.key);
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) => SprintGoalTileWidget(
                      task: goals[index],
                    ),
                  ),
                );
              },
              valueListenable: model.sprintGoalsBoxListenable,
            ),
          ],
        ),
      ),
    );
  }
}
