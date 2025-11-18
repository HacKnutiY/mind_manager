import 'package:flutter/material.dart';
import 'package:mind_manager/features/activities/models/activity_model.dart';
import 'package:mind_manager/features/activities/models/new_note_model.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({
    super.key,
  });

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ActivityScreenConfiguration arguments = ModalRoute.of(context)!
        .settings
        .arguments as ActivityScreenConfiguration;
    isNewNote = arguments.isNewNote;
    activityKey = arguments.activityKey;

    noteIndex = isNewNote == false ? arguments.noteIndex : null;

    _model = NewNoteModel(
        activityKey: activityKey ?? 1,
        isNewNote: isNewNote,
        noteIndex: noteIndex);
  }

  late NewNoteModel _model;

  int? activityKey;
  int? noteIndex;
  late bool isNewNote;
  @override
  Widget build(BuildContext context) {
    return NewNoteProvider(
      notifier: _model,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            isNewNote
                ? const _CancelNoteBtnWidget()
                : _DeleteNoteBtnWidget(noteIndex: noteIndex),
            const Expanded(
              child: SizedBox(),
            ),
            TextButton(
              onPressed: () {
                _model.saveNote(context);

                Navigator.pop(context);
              },
              child: const Text(
                "Сохранить заметку",
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: const _NewNoteScreenBody(),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    _model.dispose();
    super.dispose();
  }
}

class _DeleteNoteBtnWidget extends StatelessWidget {
  int? noteIndex;
  _DeleteNoteBtnWidget({required this.noteIndex});

  @override
  Widget build(BuildContext context) {
    final model = NewNoteProvider.read(context)?.notifier;
    return TextButton(
      onPressed: () {
        model?.deleteNote();
        Navigator.pop(context);
      },
      child: const Text(
        "Удалить заметку",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class _CancelNoteBtnWidget extends StatelessWidget {
  const _CancelNoteBtnWidget();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "Отменить",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class _NewNoteScreenBody extends StatelessWidget {
  const _NewNoteScreenBody();

  @override
  Widget build(BuildContext context) {
    NewNoteModel? model = NewNoteProvider.watch(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: TextEditingController(text: model?.name.toString()),
              autofocus: true,
              onChanged: (value) => model?.name = value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Название заметки",
                  hintStyle: TextStyle(fontWeight: FontWeight.normal)),
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: model?.text.toString()),
                maxLines: null,
                minLines: null,
                onChanged: (value) => model?.text = value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Введите заметку...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
