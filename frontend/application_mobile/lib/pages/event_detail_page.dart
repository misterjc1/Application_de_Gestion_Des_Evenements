import 'package:flutter/material.dart';
import '../models/event.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.image != null)
              Image.network(
                event.image!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, event.location),
            _buildDetailRow(Icons.calendar_today, 
                "${event.date.day}/${event.date.month}/${event.date.year} à ${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}"),
            _buildDetailRow(Icons.euro, "${event.price}€"),
            _buildDetailRow(Icons.people, "${event.maxAttendees} places maximum"),
            _buildDetailRow(Icons.person, "Organisé par: ${event.organizer}"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}