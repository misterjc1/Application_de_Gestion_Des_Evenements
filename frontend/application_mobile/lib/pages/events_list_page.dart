import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import 'event_detail_page.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    if (eventProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Erreur: ${eventProvider.error}"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => eventProvider.loadEvents(),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    if (eventProvider.events.isEmpty) {
      return const Center(child: Text("Aucun événement trouvé"));
    }

    return RefreshIndicator(
      onRefresh: () => eventProvider.loadEvents(),
      child: ListView.builder(
        itemCount: eventProvider.events.length,
        itemBuilder: (context, index) {
          final event = eventProvider.events[index];
          return EventCard(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailPage(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }
}