import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_firebase/features/posts/domain/entities/comments.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String postImageUrl;
  final DateTime timeStamp;
  List<String> likes;
  List<Comments> comments;
  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.postImageUrl,
    required this.timeStamp,
    required this.likes,
    required this.comments,
  });

  factory Post.fromMap(Map<String, dynamic> post) {
    final comment =
        (post['comments'] as List<dynamic>?)
            ?.map((e) => Comments.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];
    return Post(
      id: post['id'],
      userId: post['userId'],
      userName: post['userName'],
      text: post['text'],
      postImageUrl: post['postImageUrl'],
      timeStamp: (post['timeStamp'] as Timestamp).toDate(),
      likes: List<String>.from(post['likes'] ?? []),
      comments: comment,
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
      'comments': comments.map((comment) => comment.toJson()).toList(),
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
      comments: comments,
    );
  }
}
