import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxAttendeesController = TextEditingController();
  final _imageController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      final event = Event(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        location: _locationController.text,
        price: double.parse(_priceController.text),
        maxAttendees: int.parse(_maxAttendeesController.text),
        organizer: authProvider.user?.name ?? 'Organisateur',
        image: _imageController.text.isEmpty ? null : _imageController.text,
      );

      final success = await EventService.createEvent(event, authProvider.token!);
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        await eventProvider.loadEvents();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Événement créé avec succès!")),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la création")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un événement")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Titre *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le titre est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La description est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Lieu *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le lieu est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(context),
                        child: Text("Heure: ${_selectedTime.format(context)}"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Prix (€) *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le prix est obligatoire';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Prix invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _maxAttendeesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Nombre maximum de participants *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Nombre invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: "URL de l'image (optionnel)"),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text("Créer l'événement"),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _maxAttendeesController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}