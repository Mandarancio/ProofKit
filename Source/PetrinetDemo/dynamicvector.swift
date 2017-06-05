
public class DynamicVector {

  private var data : [Int]

  public init(){
    data = [0]
  }

  public init(_ initial_data: [Int]){
    data = initial_data
  }

  public func size() -> Int {
    return data.count
  }

  private func add_lines(_ number:Int) -> () {
    guard number > 0 else {
      return
    }

    for _ in 1...number {
      data.append(0)
    }
  }

  private func verify_access_to(_ x:Int) -> () {
    if x >= data.count {
      add_lines(x-data.count+1)
    }
  }

  subscript(x: Int) -> Int {
    get {
      let safe_x = max(Int(0), x)
      verify_access_to(safe_x)
      return data[safe_x]
    }

    set {
      let safe_x = max(Int(0), x)
      verify_access_to(safe_x)
      data[safe_x] = newValue
    }
  }

  public func to_string() -> String {
    var result = "[\n"
    for line in data {
      result.append("\(line)\n")
    }
    result.append("]\n")

    return result
  }

}
