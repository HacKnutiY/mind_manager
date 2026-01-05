import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/features/sprint/models/sprints_model.dart';

class SprintTaskTileWidget extends StatelessWidget {
  const SprintTaskTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Card(
        child: ExpansionTile(
          leading: const FlutterLogo(size: 72.0),
          title: Text("Mobile"),
          subtitle: const Text('pfdthibnm '),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          
        ),
      ),
    );
  }
}


