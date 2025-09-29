import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  List<Event> _allEvents = [];
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  bool _sortByNewest = true;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  bool get sortByNewest => _sortByNewest;

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allEvents = await EventService.fetchEvents();
      _applyFiltersAndSort();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFiltersAndSort() {
    List<Event> filteredEvents = List.from(_allEvents);
    
    if (_searchQuery.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) =>
        event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.location.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    filteredEvents.sort((a, b) {
      if (_sortByNewest) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });
    
    _events = filteredEvents;
  }

  void markEventAsDeleted(int eventId) {
    _allEvents.removeWhere((event) => event.id == eventId);
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void toggleSortOrder() {
    _sortByNewest = !_sortByNewest;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}