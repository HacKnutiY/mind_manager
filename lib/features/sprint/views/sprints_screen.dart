import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/sprint.dart';
import 'package:mind_manager/features/sprint/models/sprints_model.dart';
import 'package:mind_manager/features/sprint/views/widgets/sprint_tile_widget.dart'
    show SprintTileWidget;
import 'package:provider/provider.dart';

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
      body: ChangeNotifierProvider(
        create: (context) => _model,
        child: _SprintsBody(),
      ),
    );
  }
}

class _SprintsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SprintsModel model = context.read<SprintsModel>();

    return ValueListenableBuilder<Box<Sprint>>(
      valueListenable: model.sprintsBoxListenable,
      builder: (BuildContext context, Box<Sprint> sprintsBox, Widget? child) {
        List<Sprint> sprints = sprintsBox.values.toList().reversed.toList();

        return ListView.builder(
          itemCount: sprints.length,
          itemBuilder: (context, index) => SprintTileWidget(
            sprint: sprints[index],
          ),
        );
      },
    );
  }
}
