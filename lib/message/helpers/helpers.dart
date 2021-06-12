String getConversationId({
  required String senderId,
  required String receiverId,
}) {
  if (senderId.compareTo(receiverId) < 0) {
    return '$senderId-$receiverId';
  } else {
    return '$receiverId-$senderId';
  }
}
