import 'package:flutter/material.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/features/sprint/models/sprints_model.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_widget.dart'
    show SprintTileWidget;

class SprintsScreen extends StatefulWidget {
  const SprintsScreen({super.key});

  @override
  State<SprintsScreen> createState() => _SprintsScreenState();
}

class _SprintsScreenState extends State<SprintsScreen> {

  final _model = SprintsModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _model.toNewSprintScreen(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Спринты"),
        centerTitle: true,
      ),
      body: SprintsProvider(
        model: _model,
        child: _SprintsBody(),
      ),
    );
  }
}

class _SprintsBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SprintsModel? model = SprintsProvider.watch(context);

    return ListView.builder(
      itemCount: model?.sprints.length ?? 0,
      itemBuilder: (context, index) => SprintTileWidget(
        sprint: model?.sprints[index] ??
            Sprint(
              name: "name",
              firstDate: DateTime(0),
              lastDate: DateTime(0),
            ),
      ),
    );
  }
}
