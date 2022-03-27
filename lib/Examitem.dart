class Examitem {
  final String image_url;
  final int answer;
  final List choice_list;

  Examitem({
    required this.image_url,
    required this.answer,
    required this.choice_list,
});

  factory Examitem.fromJson(Map<String, dynamic> json) {
    return Examitem(
        image_url: json['image_url'],
        answer: json['answer'],
        choice_list: (json['choice_list'] as List).map((choice_list) => choice_list).toList() ,
    );
  }
}