class Article {
  final int id;
  String title;
  final String shortTitle;
  final List<Map<String, String>> content;
  final String imagePath;
  String category;
  final int minRead;
  final DateTime published;
  final List<int> tags;
  final bool isTagLink;
  final String link;

  Article({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.content,
    required this.imagePath,
    required this.category,
    required this.minRead,
    required this.published,
    required this.tags,
    required this.isTagLink,
    required this.link,
  });
}
