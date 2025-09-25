import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: ListTile(
        leading: event.image != null 
            ? Image.network(event.image!, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.event, size: 40),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description.length > 50 
                ? '${event.description.substring(0, 50)}...' 
                : event.description),
            const SizedBox(height: 4),
            Text('${event.location} • ${event.date.day}/${event.date.month}/${event.date.year}'),
            Text('${event.price}€ • ${event.maxAttendees} places'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}