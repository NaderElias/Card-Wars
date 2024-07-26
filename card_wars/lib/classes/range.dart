class Rangen{
  final int start;
  final int end;
  
  Rangen(this.start, this.end);
  
  bool contains(int value) {
    return value >= start && value <= end;
  }

  @override
  String toString() {
    return 'Range($start, $end)';
  }
}