
public class DynamicMatrix {

  private var data : [[Int]]

  public init(){
    data = [[0]]
  }

  public init(_ initial_data: [[Int]]){
    data = initial_data
    var columnNumber = 0
    for line in data {
      if line.count > columnNumber {
        columnNumber = line.count
      }
    }
    for i in 0...(data.count-1) {
      while data[i].count < columnNumber {
        data[i].append(0)
      }
    }
  }

  public func dim() -> (Int, Int){
    if data.count == 0 {
      return (0, 0)
    }
    return (data.count, data[0].count)
  }

  private func add_lines(_ number:Int) -> () {
    guard number > 0 else {
      return
    }

    for _ in 1...number {
      data.append([])
      for _ in 1...data[0].count {
        data[data.count-1].append(0)
      }
    }
  }

  private func add_columns(_ number:Int) -> () {
    guard number > 0 else {
      return
    }

    for i in 0...(data.count-1) {
      for _ in 1...number {
        data[i].append(0)
      }
    }
  }

  private func verify_access_to(_ x:Int, _ y: Int) -> () {
    if x >= data.count {
      add_lines(x-data.count+1)
    }
    if y >= data[0].count {
      add_columns(y-data[0].count+1)
    }
  }

  subscript(x: Int, y: Int) -> Int {
    get {
      let safe_x = max(Int(0), x)
      let safe_y = max(Int(0), y)
      verify_access_to(safe_x, safe_y)
      return data[safe_x][safe_y]
    }

    set {
      let safe_x = max(Int(0), x)
      let safe_y = max(Int(0), y)
      verify_access_to(safe_x, safe_y)
      data[safe_x][safe_y] = newValue
    }
  }

  public func delete_row(_ nb: Int) -> () {
    data.remove(at:nb)
  }

  public func delete_column(_ nb: Int) -> () {
    for i in 0 ... (data.count-1) {
      data[i].remove(at:nb)
    }
  }

  public func transposed() -> DynamicMatrix {
    let result = DynamicMatrix()

    for i in 0 ... ((dim().0) - 1) {
      for j in 0 ... ((dim().1) - 1) {
        result[(j,i)] = self[(i,j)]
      }
    }

    return result
  }

  // = t_invariant with transposed matrix
  public func is_p_invariant(_ v: DynamicVector) -> Bool {
    let columnNumber = max(dim().0, v.size())

    for i in 1 ... dim().1 {
      var lineProduct = 0
      for j in 0 ... (columnNumber-1){
        lineProduct += self[(j, i)] * v[j]
      }
      if lineProduct != 0 {
        return false
      }
    }
    return true
  }

  public func is_t_invariant(_ v: DynamicVector) -> Bool {
    let columnNumber = max(dim().1, v.size())

    for i in 1 ... dim().0 {
      var lineProduct = 0
      for j in 0 ... (columnNumber-1){
        lineProduct += self[(j, i)] * v[j]
      }
      if lineProduct != 0 {
        return false
      }
    }
    return true
  }

  private func get_gcd(_ a: Int, _ b: Int) -> Int {
    var a_ = a
    var b_ = b
    while b_ != 0 {
      let t = b_
      b_ = a_ % b_
      a_ = t
    }
    return a_
  }

  //Farkas Algorithm
  public func get_p_invariants() -> [[Int]] {

    //Construction of D_0
    let farkMat = DynamicMatrix(data)
    var n = dim().0
    let m = dim().1
    for i in 0 ... (n-1) {
      let col = m+i // I don't know why Swift doesn't accept farkMat[(i, m+i)]
      farkMat[(i, col)] = 1
    }

    //Main alg loop
    for i in 0 ... (m-1) {
      n = farkMat.dim().0
      if n < 2 {
        break
      }
      //for d1,d2 rows in D_(i-1)
      for d1 in 0 ... (n-2) {
        for d2 in d1+1 ... (n-1){
          //such that d1(i) and d2(i) have opposite signs
          if farkMat[(d1, i)] * farkMat[(d2,i)] < 0 {
            var d : [Int]
            d = []
            var gcd = 0
            //d = |d2(i)|d1 + |d1(i)|d2 (and compute gcd for next step)
            for j in 0 ... (m+n-1) {
              d.append(abs(farkMat[(d2, i)]) * farkMat[(d1, j)] + abs(farkMat[(d1, i)]) * farkMat[(d2, j)])
              gcd = get_gcd(d[j],gcd)
            }
            //divide d by gcd of all d components (don't do anything if d is full of zeros <=> gcd = 0
            if gcd != 0 {
              for j in 0 ... (m+n-1) {
                d[j] /= gcd
              }
            }
            farkMat.data.append(d)
          }
        }
      }
      //Delete all rows whose ith component != 0
      for j in (0 ... (n-1)).reversed() { //reversed because of index changing at deletion reasons
        if farkMat[(j, i)] != 0 {
          farkMat.delete_row(j)
        }
      }
    }

    //if n == 0, we can already return an empty array
    if n == 0 {
      return []
    }

    //Delete first m columns
    for _ in 0 ... (m-1) {
      farkMat.delete_column(0)
    }

    return farkMat.data
  }

  //Farkas Algorithm on transposed matrix
  public func get_t_invariants() -> [[Int]] {
    let transp = transposed()

    return transp.get_p_invariants()
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
