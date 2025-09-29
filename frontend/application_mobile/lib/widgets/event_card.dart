import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final bool isDeleted;

  const EventCard({
    super.key, 
    required this.event, 
    required this.onTap,
    this.isDeleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDeleted ? 0.6 : 1.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isDeleted 
                ? Border.all(color: Colors.grey.withOpacity(0.5), width: 1)
                : null,
          ),
          child: Stack(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDeleted 
                        ? Colors.grey[300] 
                        : Colors.deepPurple[50],
                  ),
                  child: event.image != null && !isDeleted
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            event.image!, 
                            width: 50, 
                            height: 50, 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.event,
                                size: 30,
                                color: Colors.deepPurple[400],
                              );
                            },
                          ),
                        )
                      : Icon(
                          isDeleted ? Icons.event_busy : Icons.event,
                          size: 30,
                          color: isDeleted 
                              ? Colors.grey[600] 
                              : Colors.deepPurple[400],
                        ),
                ),
                title: Text(
                  event.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDeleted ? Colors.grey[600] : Colors.black,
                    decoration: isDeleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      event.description.length > 60 
                          ? '${event.description.substring(0, 60)}...' 
                          : event.description,
                      style: TextStyle(
                        color: isDeleted ? Colors.grey[500] : Colors.grey[700],
                        decoration: isDeleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: isDeleted ? Colors.grey : Colors.deepPurple),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDeleted ? Colors.grey : Colors.grey[600],
                              decoration: isDeleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: isDeleted ? Colors.grey : Colors.deepPurple),
                        const SizedBox(width: 4),
                        Text(
                          '${event.date.day}/${event.date.month}/${event.date.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDeleted ? Colors.grey : Colors.grey[600],
                            decoration: isDeleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.euro, size: 14, color: isDeleted ? Colors.grey : Colors.deepPurple),
                        const SizedBox(width: 4),
                        Text(
                          '${event.price}€',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDeleted ? Colors.grey : Colors.grey[600],
                            decoration: isDeleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.people, size: 14, color: isDeleted ? Colors.grey : Colors.deepPurple),
                        const SizedBox(width: 4),
                        Text(
                          '${event.maxAttendees} places',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDeleted ? Colors.grey : Colors.grey[600],
                            decoration: isDeleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDeleted 
                        ? Colors.grey[300] 
                        : Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDeleted ? Colors.grey[600] : Colors.deepPurple[400],
                  ),
                ),
                onTap: isDeleted ? null : onTap,
              ),
              if (isDeleted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Supprimé',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}