class ObsModel {
  final int user_id;
  final String title;
  final DateTime create_at;
  final String date;
  final String horain;

  ObsModel(
      {required this.user_id,
      required this.title,
      required this.create_at,
      required this.date,
      required this.horain});

  factory ObsModel.fromJson(Map<String, dynamic> data) {
    return ObsModel(
        user_id: data['user_id'],
        title: data['title'],
        create_at: DateTime.parse(data['created_at']),
        date: data['date'],
        horain: data['horain']);
  }
}
