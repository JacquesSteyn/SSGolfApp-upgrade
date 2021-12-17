class Benchmark {
  int pro = 0;
  int zero_to_nine = 0;
  int ten_to_nineteen = 0;
  int twenty_to_twenty_nine = 0;
  int thirty_plus = 0;
  int threshold = 0;

  Benchmark([data]) {
    this.pro = data['pro'] == 0 ? 0 : int.parse(data['pro']);
    this.zero_to_nine =
        data['zero_to_nine'] == 0 ? 0 : int.parse(data['zero_to_nine']);
    this.ten_to_nineteen =
        data['ten_to_nineteen'] == 0 ? 0 : int.parse(data['ten_to_nineteen']);
    this.twenty_to_twenty_nine = data['twenty_to_twenty_nine'] == 0
        ? 0
        : int.parse(data['twenty_to_twenty_nine']);
    this.thirty_plus =
        data['thirty_plus'] == 0 ? 0 : int.parse(data['thirty_plus']);
    this.threshold = data['threshold'] == 0 ? 0 : int.parse(data['threshold']);
  }

  Benchmark.init() {
    this.pro = 0;
    this.ten_to_nineteen = 0;
    this.thirty_plus = 0;
    this.threshold = 0;
    this.twenty_to_twenty_nine = 0;
    this.zero_to_nine = 0;
  }
}
