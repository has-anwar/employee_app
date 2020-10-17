class ChildData {
  int childId;
  String childName;
  String dob;
  int parentId;
  int age;
  String fatherName;
  String motherName;

  ChildData(this.childId, this.childName, this.dob, this.parentId, this.age,
      this.fatherName, this.motherName);

  void printChildData() {
    print(childName);
    print(childId);
    print(dob);
    print(parentId);
    print(fatherName);
    print(motherName);
  }
}
