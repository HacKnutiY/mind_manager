import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/features/sprint/models/sprints_model.dart';

class SprintTileWidget extends StatelessWidget {
  final Sprint sprint;
  const SprintTileWidget({
    super.key,
    required this.sprint,
  });

  @override
  Widget build(BuildContext context) {
    SprintsModel? model = SprintsProvider.watch(context);
    model?.loadSprintTasks(sprint.key);//исправить
    String firstDate =
        "${sprint.firstDate?.day}/${sprint.firstDate?.month}/${sprint.firstDate?.year}";
    String lastDate =
        "${sprint.lastDate?.day}/${sprint.lastDate?.month}/${sprint.lastDate?.year}";

    return GestureDetector(
      onLongPress: () => model.toSprintScreen(context, sprint.key),
      child: Card(
        child: ExpansionTile(
          leading: const FlutterLogo(size: 72.0),
          title: Text("${sprint.name} [$firstDate - $lastDate]"),
          subtitle: const Text('Активный спринт'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          children: model!
              .sprintTasks,
        ),
      ),
    );
  }
}



// Card(
//           child: ExpansionTile(
//             title: Text('ExpansionTile 1'),
//             subtitle: Text('Trailing expansion arrow icon'),
//             children: <Widget>[ListTile(title: Text('This is tile number 1'))],
//           ),
//         ),