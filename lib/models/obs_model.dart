class ObsModel {
  final int user_id;
  final String create_at;
  final String title;
  final String date;
  final String horain;

  ObsModel(
      {required this.user_id,
      required this.create_at,
      required this.title,
      required this.date,
      required this.horain});

  factory ObsModel.fromJson(Map<String, dynamic> data) {
    return ObsModel(
        user_id: data['user_id'],
        create_at: data['create_at'],
        title: data['title'],
        date: data['date'],
        horain: data['horain']);
  }
}
