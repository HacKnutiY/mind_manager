import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mind_manager/features/activities/views/widgets/term_goal_widget.dart';

import '../models/activity_model.dart';

class ActivitiyScreen extends StatefulWidget {
  final int activityKey;
  const ActivitiyScreen({super.key, required this.activityKey});
  @override
  State<ActivitiyScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivitiyScreen> {
  @override
  void initState() {
    super.initState();
    activityKey = widget.activityKey;
    _model = ActivityModel(activityKey: activityKey);
  }

  late int activityKey;
  ActivityModel? _model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          activeIcon: Icons.add,
          icon: Icons.add,
          animatedIcon: AnimatedIcons.menu_close,
          children: <SpeedDialChild>[
            SpeedDialChild(
              onTap: () {
                _model?.toNewNoteScreen(context,
                    activityKey: activityKey, isNewNote: true);
              },
              child: const Icon(Icons.notes_rounded),
              label: "Заметка",
            ),
            SpeedDialChild(
              onTap: () => _model?.toNewTermGoal(context),
              child: const Icon(Icons.sports_score),
              label: "Долгосрочная цель",
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(_model!.activity?.name ?? ""),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityProvider(
            model: _model!,
            child: const _ActivityBodyWidget(),
          ),
        ));
  }
/*
  @override
  Future<void> dispose() async {
    _model!.dispose();
    super.dispose();
  }
  */
}

class _ActivityBodyWidget extends StatelessWidget {
  const _ActivityBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = ActivityProvider.watch(context);

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
        const NotesList(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: const ButtonStyle(
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            onPressed: () {
              model?.deleteActivity();
              Navigator.pop(context);
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

// ----------------------------Builders-------------------------------//
class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel? model = ActivityProvider.watch(context);

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: model?.activityNotes.length ?? 0,
        itemBuilder: (context, index) => NoteTileWidget(
          noteName: model!.activityNotes[index].name,
          noteIndex: index,
        ),
      ),
    );
  }
}

class TermGoalsList extends StatelessWidget {
  const TermGoalsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ActivityModel? model = ActivityProvider.watch(context);

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: model?.activityTermGoals.length ?? 0,
        itemBuilder: (context, index) => TermGoalTileWidget(
          goal: model!.activityTermGoals[index],
        ),
      ),
    );
  }
}

//------------------------WIDGET TILES-----------------------------//
// class TermGoalTileWidget extends StatelessWidget {
//   final TermGoal goal;
//   final goalIndexInList;

//   const TermGoalTileWidget(
//       {super.key, required this.goal, required this.goalIndexInList});

//   @override
//   Widget build(BuildContext context) {
//     final model = ActivityProvider.read(context)?.notifier;

//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(0),
//           child: Container(
//             width: 350,
//             decoration: BoxDecoration(
//                 color: Colors.blueGrey,
//                 borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         goal.text,
//                         softWrap: false,
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             const TextSpan(
//                                 text: "Срок до: ",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                             TextSpan(
//                                 text:
//                                     "${goal.lastDate?.day}/${goal.lastDate?.month}/${goal.lastDate?.year}"),
//                           ],
//                         ),
//                       ),
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                                 text: "Статус: ",
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                             TextSpan(text: "Не выполнена"),
//                           ],
//                         ),
//                       ),
//                       RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                                 text: "Актуальность: ",
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                             TextSpan(text: "Активная цель"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () {
//                           model?.deleteTermGoal(goalIndexInList);
//                         },
//                         child: const Text(
//                           "Удалить",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () {},
//                         child: const Text(
//                           "Завершить",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 30,
//         ),
//       ],
//     );
//   }
// }

class NoteTileWidget extends StatelessWidget {
  final String noteName;
  final int noteIndex;

  const NoteTileWidget(
      {super.key, required this.noteName, required this.noteIndex});

  @override
  Widget build(BuildContext context) {
    var model = ActivityProvider.read(context)?.model;
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => {
          model?.toNoteScreen(context, noteIndex: noteIndex, isNewNote: false)
        },
        child: Text(noteName),
      ),
    );
  }
}
