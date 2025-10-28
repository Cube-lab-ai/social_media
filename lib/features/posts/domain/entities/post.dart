import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String postImageUrl;
  final DateTime timeStamp;
  List<String> likes;
  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.postImageUrl,
    required this.timeStamp,
    required this.likes,
  });

  factory Post.fromMap(Map<String, dynamic> post) {
    return Post(
      id: post['id'],
      userId: post['userId'],
      userName: post['userName'],
      text: post['text'],
      postImageUrl: post['postImageUrl'],
      timeStamp: (post['timeStamp'] as Timestamp).toDate(),
      likes: List<String>.from(post['likes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'postImageUrl': postImageUrl,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'likes': likes,
    };
  }

  Post copyWith({String? newImageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      postImageUrl: newImageUrl ?? postImageUrl,
      timeStamp: timeStamp,
      likes: likes,
    );
  }
}
