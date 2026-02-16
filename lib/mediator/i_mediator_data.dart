abstract class IMediatorData {
  List<Map<String, dynamic>> get agendaItems;
  void addAgendaItem(Map<String, dynamic> item);
  void updateAgendaItem(Map<String, dynamic> item);
  void removeAgendaItem(int id);

  List<Map<String, dynamic>> get summaryItems;
  void addSummaryItem(Map<String, dynamic> item);
  void updateSummaryItem(Map<String, dynamic> item);
}