import 'package:flutter/material.dart';

const numSteps = 10;
const fieldsPerStep = 10;

class FormStepper extends StatefulWidget {
  const FormStepper({super.key});

  @override
  State<FormStepper> createState() => _FormStepperState();
}

class _FormStepperState extends State<FormStepper> {
  late final GlobalKey<FormState> _formKey;
  int _currentStep = 0;
  // Maps step number to the number of fields in that step for which .save()
  // has been called.
  late Map<int, int> _savedFieldsPerStep;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _resetMap();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stepper(
        steps: _generateSteps(),
        currentStep: _currentStep,
        onStepTapped: (i) => setState(() => _currentStep = i),
        controlsBuilder: (context, details) => ElevatedButton(
          onPressed: () {
            _formKey.currentState?.save();
            print(_savedFieldsPerStep);
            _resetMap();
          },
          child: const Text('Save'),
        ),
      ),
    );
  }

  List<Step> _generateSteps() {
    return List.generate(
      numSteps,
      (stepIndex) => Step(
        title: Text('Step $stepIndex'),
        content: Column(
          children: List.generate(
            fieldsPerStep,
            (index) => TextFormField(
              onSaved: (newValue) => _incrementMapValue(stepIndex),
            ),
          ),
        ),
      ),
    );
  }

  void _incrementMapValue(int stepIndex) {
    _savedFieldsPerStep[stepIndex] = _savedFieldsPerStep[stepIndex]! + 1;
  }

  void _resetMap() {
    _savedFieldsPerStep = {
      for (var i in List.generate(numSteps, (i) => i)) i: 0
    };
  }
}
