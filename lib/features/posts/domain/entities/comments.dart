
import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String id;
  String userId;
  String postId;
  String userName;
  String text;
  DateTime timestamp;

  Comments({
    required this.id,
    required this.userId,
    required this.postId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'userName': userName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Comments.fromMap(Map<String, dynamic> commentData) {
    return Comments(
      id: commentData['id'],
      userId: commentData['userId'],
      postId: commentData['postId'],
      userName: commentData['userName'],
      text: commentData['text'],
      timestamp: (commentData['timestamp'] as Timestamp).toDate(),
    );
  }
}
