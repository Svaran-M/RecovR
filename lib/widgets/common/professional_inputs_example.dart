import 'package:flutter/material.dart';
import 'professional_inputs.dart';
import '../../theme/app_theme.dart';

/// Example screen demonstrating all professional input components
/// This file serves as a visual reference and can be used for manual testing
class ProfessionalInputsExample extends StatefulWidget {
  const ProfessionalInputsExample({super.key});

  @override
  State<ProfessionalInputsExample> createState() => _ProfessionalInputsExampleState();
}

class _ProfessionalInputsExampleState extends State<ProfessionalInputsExample> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  double _sliderValue = 50;
  double _painLevel = 5;
  bool _checkbox1 = false;
  bool _checkbox2 = true;
  bool _switch1 = false;
  bool _switch2 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Inputs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        children: [
          // Text Fields Section
          Text(
            'Text Fields',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          ProfessionalTextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              helperText: 'As it appears on your ID',
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          ProfessionalTextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Sliders Section
          Text(
            'Sliders',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          ProfessionalLabeledSlider(
            label: 'Volume',
            value: _sliderValue,
            onChanged: (value) => setState(() => _sliderValue = value),
            min: 0,
            max: 100,
            divisions: 20,
            minLabel: 'Mute',
            maxLabel: 'Max',
          ),
          const SizedBox(height: AppTheme.spacing24),
          ProfessionalLabeledSlider(
            label: 'Pain Level',
            value: _painLevel,
            onChanged: (value) => setState(() => _painLevel = value),
            min: 0,
            max: 10,
            divisions: 10,
            minLabel: 'No Pain',
            maxLabel: 'Severe',
            activeColor: _getPainColor(_painLevel),
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Checkboxes Section
          Text(
            'Checkboxes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              ProfessionalCheckbox(
                value: _checkbox1,
                onChanged: (value) => setState(() => _checkbox1 = value ?? false),
              ),
              const SizedBox(width: AppTheme.spacing12),
              const Text('Simple checkbox'),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          ProfessionalCheckboxListTile(
            value: _checkbox2,
            onChanged: (value) => setState(() => _checkbox2 = value),
            title: const Text('Checkbox with title'),
            subtitle: const Text('This includes a subtitle for more context'),
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Switches Section
          Text(
            'Switches',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              ProfessionalSwitch(
                value: _switch1,
                onChanged: (value) => setState(() => _switch1 = value),
              ),
              const SizedBox(width: AppTheme.spacing12),
              const Text('Simple switch'),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          ProfessionalSwitchListTile(
            value: _switch2,
            onChanged: (value) => setState(() => _switch2 = value),
            title: const Text('Enable notifications'),
            subtitle: const Text('Receive daily reminders for your exercises'),
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Combined Example
          Text(
            'Form Example',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfessionalTextField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  ProfessionalTextField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  ProfessionalCheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Remember me'),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPainColor(double value) {
    if (value < 3.5) {
      return AppTheme.success(context);
    } else if (value < 7) {
      return AppTheme.warning(context);
    } else {
      return AppTheme.error(context);
    }
  }
}
