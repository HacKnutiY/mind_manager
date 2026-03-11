import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:mind_manager/data/entities/note.dart';
import 'package:mind_manager/data/entities/term_goal.dart';
import 'package:mind_manager/features/activities/views/widgets/term_goal_tile_widget.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';

class ActivityScreen extends StatefulWidget {
  final int activityKey;
  const ActivityScreen({super.key, required this.activityKey});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    activityKey = widget.activityKey;
  }

  late final int activityKey;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityModel(activityKey: activityKey),
      child: _ActivityWrapperWidget(),
    );
  }
}

class _ActivityWrapperWidget extends StatelessWidget {
  _ActivityWrapperWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel model = context.read<ActivityModel>();
    return Scaffold(
      floatingActionButton: const _SpeelDialMenuWidget(),
      appBar: AppBar(
        title: Text(model.activity?.name ?? ""),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: _ActivityBodyWidget(),
      ),
    );
  }
}

class _ActivityBodyWidget extends StatelessWidget {
  const _ActivityBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel model = context.read<ActivityModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Долгосрочные цели",
          style: TextStyle(fontSize: 18),
        ),
        const TermGoalsList(),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Заметки",
          style: TextStyle(fontSize: 18),
        ),
        const Expanded(
          child: NotesList(),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: ElevatedButton(
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  vertical: 20,
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            onPressed: () async {
              await model.deleteActivity(context);
            },
            child: const Text(
              "Удалить направление",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpeelDialMenuWidget extends StatelessWidget {
  const _SpeelDialMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel model = context.read<ActivityModel>();
    return SpeedDial(
      activeIcon: Icons.add,
      icon: Icons.add,
      animatedIcon: AnimatedIcons.menu_close,
      children: <SpeedDialChild>[
        SpeedDialChild(
          onTap: () {
            model.toNewNoteScreen(context, isNewNote: true);
          },
          child: const Icon(Icons.notes_rounded),
          label: "Заметка",
        ),
        SpeedDialChild(
          onTap: () => model.toNewTermGoal(context),
          child: const Icon(Icons.sports_score),
          label: "Долгосрочная цель",
        ),
      ],
    );
  }
}

// ----------------------------TermGoals Widgets-------------------------------//

class TermGoalsList extends StatelessWidget {
  const TermGoalsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<TermGoal>>(
      builder: (BuildContext context, Box<TermGoal> actualsBox, Widget? child) {
        List<TermGoal> filteredActuals = context
            .read<ActivityModel>()
            .getFilteredTerms(context.read<ActivityModel>().activityKey);
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredActuals.length,
            itemBuilder: (context, index) => TermGoalTileWidget(
              goal: filteredActuals[index],
            ),
          ),
        );
      },
      valueListenable: context.read<ActivityModel>().termGoalsListenable,
    );
  }
}

//------------------------Notes Widgets-----------------------------//

class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel model = context.read<ActivityModel>();

    return ValueListenableBuilder<Box<Note>>(
      valueListenable: model.notesListenable,
      builder: (context, Box<Note> notesBox, child) {
        // фильтрация по ключу активности
        int activityKey = context.read<ActivityModel>().activityKey;
        List<Note> filteredNotes =
            context.read<ActivityModel>().getFilteredNotes(activityKey);

        return ListView.builder(
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) => NoteTileWidget(
            note: filteredNotes[index],
          ),
        );
      },
    );
  }
}

class NoteTileWidget extends StatelessWidget {
  final Note note;

  const NoteTileWidget({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel model = context.read<ActivityModel>();

    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () =>
            {model.toNoteScreen(context, isNewNote: false, note: note)},
        child: Text(note.name),
      ),
    );
  }
}
