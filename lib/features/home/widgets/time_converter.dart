String convertTimeFormat(String timeString) {
  final dateTime = DateTime.parse(timeString);
  final now = DateTime.now();

  // Calculate the difference between the given time and the current time
  final difference = now.difference(dateTime);

  final daysDifference = difference.inDays;
  final hoursDifference = difference.inHours - (daysDifference * 24);

  if (daysDifference == 0) {
    // Display only hours if it's less than a day
    return '${hoursDifference} hours ago';
  } else if (daysDifference == 1) {
    // Display "1 day ago" if it's just one day
    return '1 day ago';
  } else {
    // Display the relative time in days and hours format
    return '${daysDifference} days ${hoursDifference} hours ago';
  }
}
