import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:nomba/helpers/string_formatter.dart';

class CreateOrEditRoutine extends StatefulWidget {
  final RoutineModel? routineModel;

  const CreateOrEditRoutine({Key? key, this.routineModel}) : super(key: key);

  @override
  State<CreateOrEditRoutine> createState() => _CreateOrEditRoutineState();
}

class _CreateOrEditRoutineState extends State<CreateOrEditRoutine> {
  final _formKey = GlobalKey<FormState>();
  String? title, description;
  RoutineFrequency? _frequency = RoutineFrequency.hourly;
  final _loading = ValueNotifier(false);
  late final bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.routineModel != null;
    if (_isEditing) {
      title = widget.routineModel!.title;
      description = widget.routineModel!.description;
      _frequency = widget.routineModel!.frequency;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Routine' : 'Create Routine'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Routine title',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: validator,
                  onSaved: (v) => title = v,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: description,
                  decoration: const InputDecoration(
                    labelText: 'Routine description',
                  ),
                  textInputAction: TextInputAction.done,
                  maxLines: 4,
                  minLines: 1,
                  validator: validator,
                  onSaved: (v) => description = v,
                ),
                if (!_isEditing) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<RoutineFrequency>(
                    value: _frequency,
                    items: RoutineFrequency.values
                        .map(
                          (f) => DropdownMenuItem<RoutineFrequency>(
                            value: f,
                            child: Text(toInitialCaps(f.name)),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Routine frequency',
                    ),
                    onChanged: (v) => setState(() => _frequency = v),
                    validator: validator,
                    onSaved: (v) => _frequency = v,
                  ),
                ],
                const SizedBox(
                  height: 30,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _loading,
                  builder: (context, loading, child) {
                    return ElevatedButton(
                      onPressed: loading ? null : _onSubmit,
                      child: Text(_isEditing ? 'Edit' : 'Create'),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validator(dynamic v) {
    bool isValid;
    if (v is String) {
      isValid = v.isNotEmpty == true;
    } else {
      isValid = v != null;
    }

    return isValid ? null : 'Required Field';
  }

  void _onSubmit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;
    formState.save();

    if (_isEditing) {
      _onEdit();
    } else {
      _onCreate();
    }
  }

  void _onEdit() async {
    _loading.value = true;

    final model = RoutineModel(
      title: title!,
      description: description!,
      createdAt: widget.routineModel!.createdAt,
      doneSessions: widget.routineModel!.doneSessions,
      frequency: widget.routineModel!.frequency,
    );

    final snackBarMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final response =
        await BlocProvider.of<RoutineBlocCubit>(context).editRoutine(model);

    if (response != null) {
      snackBarMessenger.showSnackBar(SnackBar(content: Text(response)));
      _loading.value = false;
    } else {
      navigator.pop();
    }
  }

  void _onCreate() async {
    _loading.value = true;

    final model = RoutineModel(
      title: title!,
      description: description!,
      createdAt: DateTime.now(),
      doneSessions: const {},
      frequency: _frequency!,
    );

    final snackBarMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final response = await BlocProvider.of<RoutineBlocCubit>(context)
        .createNewRoutine(model);

    if (response != null) {
      snackBarMessenger.showSnackBar(SnackBar(content: Text(response)));
      _loading.value = false;
    } else {
      navigator.pop();
    }
  }
}
