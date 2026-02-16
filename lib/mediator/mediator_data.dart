part of 'mediator.dart';

class MediatorData implements IMediatorData {
  final _agendaItems = List<Map<String, dynamic>>.from(LiteStorage.read('agendas') ?? <Map<String, dynamic>>[]);
  final _summaryItems = List<Map<String, dynamic>>.from(LiteStorage.read('summaries') ?? <Map<String, dynamic>>[]);

  @override
  List<Map<String, dynamic>> get agendaItems => _agendaItems;

  @override
  void addAgendaItem(Map<String, dynamic> item) {
    _agendaItems.add(item);
    LiteStorage.write('agendas', _agendaItems);
  }

  @override
  void updateAgendaItem(Map<String, dynamic> item) {
    int index = _agendaItems.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      _agendaItems[index] = item;
      LiteStorage.write('agendas', _agendaItems);
    }
  }

  @override
  void removeAgendaItem(int id) {
    _agendaItems.removeWhere((item) => item['id'] == id);
    LiteStorage.write('agendas', _agendaItems);
  }

  @override
  List<Map<String, dynamic>> get summaryItems => _summaryItems;

  @override
  void addSummaryItem(Map<String, dynamic> item) {
    _summaryItems.add(item);
    LiteStorage.write('summaries', _summaryItems);
  }

  @override
  void updateSummaryItem(Map<String, dynamic> item) {
    int index = _summaryItems.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      _summaryItems[index] = item;
      LiteStorage.write('summaries', _summaryItems);
    }
  }
}