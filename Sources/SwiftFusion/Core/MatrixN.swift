public struct Matrix3: Differentiable & Equatable & KeyPathIterable & EuclideanVectorN & AdditiveArithmetic {
  public init<Source>(_ scalars: Source) where Source : Collection, Source.Element == Double {
    precondition(scalars.count == 9)
    
    var iter = scalars.makeIterator()
    self.s00 = iter.next()!
    self.s01 = iter.next()!
    self.s02 = iter.next()!
    self.s10 = iter.next()!
    self.s11 = iter.next()!
    self.s12 = iter.next()!
    self.s20 = iter.next()!
    self.s21 = iter.next()!
    self.s22 = iter.next()!
  }
  
  public typealias TangentVector = Matrix3
  
  /// The dimension of the vector.
  public static var dimension: Int { return 9 }
  
  public static var standardBasis: [Self] {
    var result = Array(repeating: Self.zero, count: 9)
    let _ = (0..<9).map { result[$0][$0 / 3, $0 % 3] = 1.0 }
    return result
  }
  
  public mutating func move(along direction: TangentVector) {
    self.s00 += direction.s00
    self.s01 += direction.s01
    self.s02 += direction.s02
    self.s10 += direction.s10
    self.s11 += direction.s11
    self.s12 += direction.s12
    self.s20 += direction.s20
    self.s21 += direction.s21
    self.s22 += direction.s22
  }
  
  @differentiable
  public static func *= (lhs: inout Matrix3, rhs: Double) {
    lhs.s00 *= rhs
    lhs.s01 *= rhs
    lhs.s02 *= rhs
    lhs.s10 *= rhs
    lhs.s11 *= rhs
    lhs.s12 *= rhs
    lhs.s20 *= rhs
    lhs.s21 *= rhs
    lhs.s22 *= rhs
  }
  
  @differentiable
  public static func += (lhs: inout Matrix3, rhs: Matrix3) {
    lhs.s00 += rhs.s00
    lhs.s01 += rhs.s01
    lhs.s02 += rhs.s02
    lhs.s10 += rhs.s10
    lhs.s11 += rhs.s11
    lhs.s12 += rhs.s12
    lhs.s20 += rhs.s20
    lhs.s21 += rhs.s21
    lhs.s22 += rhs.s22
  }
  
  @differentiable
  public static func -= (lhs: inout Matrix3, rhs: Matrix3) {
    lhs.s00 -= rhs.s00
    lhs.s01 -= rhs.s01
    lhs.s02 -= rhs.s02
    lhs.s10 -= rhs.s10
    lhs.s11 -= rhs.s11
    lhs.s12 -= rhs.s12
    lhs.s20 -= rhs.s20
    lhs.s21 -= rhs.s21
    lhs.s22 -= rhs.s22
  }
  
  @differentiable
  public func dot(_ other: Matrix3) -> Double {
    return self.s00 * other.s00
      + self.s01 * other.s01
      + self.s02 * other.s02
      + self.s10 * other.s10
      + self.s11 * other.s11
      + self.s12 * other.s12
      + self.s20 * other.s20
      + self.s21 * other.s21
      + self.s22 * other.s22
  }
  
  public var scalars: [Double] {
    [
      s00, s10, s20,
      s01, s11, s21,
      s02, s12, s22
    ]
  }
  
  var s00, s01, s02: Double
  var s10, s11, s12: Double
  var s20, s21, s22: Double
  
  public var columnCount: Int {
    3
  }
  
  public var rowCount: Int {
    3
  }
  
  public static var identity: Matrix3 {
    return Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)
  }
  
  public static var zero: Matrix3 {
    return Matrix3(0, 0, 0, 0, 0, 0, 0, 0, 0)
  }
  
  @differentiable
  public
  init(
    _ s00: Double, _ s01: Double, _ s02: Double,
    _ s10: Double, _ s11: Double, _ s12: Double,
    _ s20: Double, _ s21: Double, _ s22: Double
  ) {
    self.s00 = s00
    self.s01 = s01
    self.s02 = s02
    self.s10 = s10
    self.s11 = s11
    self.s12 = s12
    self.s20 = s20
    self.s21 = s21
    self.s22 = s22
  }
  
  @differentiable
  public
  init(stacking row0: Vector3, _ row1: Vector3, _ row2: Vector3) {
    self.init(
      row0.x, row0.y, row0.z,
      row1.x, row1.y, row1.z,
      row2.x, row2.y, row2.z
    )
  }
  
  @differentiable
  public
  init(columns col0: Vector3, _ col1: Vector3, _ col2: Vector3) {
    self.init(
      col0.x, col1.x, col2.x,
      col0.y, col1.y, col2.y,
      col0.z, col1.z, col2.z
    )
  }
  
  @differentiable
  public static func + (_ lhs: Matrix3, _ rhs: Matrix3) -> Matrix3 {
    Matrix3(lhs.s00 + rhs.s00, lhs.s01 + rhs.s01, lhs.s02 + rhs.s02,
            lhs.s10 + rhs.s10, lhs.s11 + rhs.s11, lhs.s12 + rhs.s12,
            lhs.s20 + rhs.s20, lhs.s21 + rhs.s21, lhs.s22 + rhs.s22)
  }
  
  @differentiable
  public static func / (_ lhs: Matrix3, _ rhs: Double) -> Matrix3 {
    Matrix3(lhs.s00 / rhs, lhs.s01 / rhs, lhs.s02 / rhs,
            lhs.s10 / rhs, lhs.s11 / rhs, lhs.s12 / rhs,
            lhs.s20 / rhs, lhs.s21 / rhs, lhs.s22 / rhs)
  }
  
  @differentiable
  public static func * (_ scalar: Double, _ mat: Matrix3) -> Matrix3 {
    Matrix3(scalar * mat.s00, scalar * mat.s01, scalar * mat.s02,
            scalar * mat.s10, scalar * mat.s11, scalar * mat.s12,
            scalar * mat.s20, scalar * mat.s21, scalar * mat.s22)
  }
  
  @differentiable
  public func transposed() -> Matrix3 {
    Matrix3(s00, s10, s20,
            s01, s11, s21,
            s02, s12, s22)
  }
  
  @differentiable
  public var vec: Vector9 {
    get {
      Vector9(s00, s01, s02, s10, s11, s12, s20, s21, s22)
    }
  }
  
  @differentiable
  public subscript (_ row: Int, _ col: Int) -> Double {
    get {
      switch (row, col) {
      case (0, 0):
        return s00
      case (0, 1):
        return s01
      case (0, 2):
        return s02
      case (1, 0):
        return s10
      case (1, 1):
        return s11
      case (1, 2):
        return s12
      case (2, 0):
        return s20
      case (2, 1):
        return s21
      case (2, 2):
        return s22
      case (_, _):
        fatalError("Index out of range")
      }
    }
    set(val) {
      switch (row, col) {
      case (0, 0):
        s00 = val
      case (0, 1):
        s01 = val
      case (0, 2):
        s02 = val
      case (1, 0):
        s10 = val
      case (1, 1):
        s11 = val
      case (1, 2):
        s12 = val
      case (2, 0):
        s20 = val
      case (2, 1):
        s21 = val
      case (2, 2):
        s22 = val
      case (_, _):
        fatalError("Index out of range")
      }
    }
  }
}


/// M * v where v is 3x1
@differentiable
public func matvec(_ lhs: Matrix3, _ rhs: Vector3) -> Vector3 {
  return Vector3(
    lhs.s00 * rhs.x + lhs.s01 * rhs.y + lhs.s02 * rhs.z,
    lhs.s10 * rhs.x + lhs.s11 * rhs.y + lhs.s12 * rhs.z,
    lhs.s20 * rhs.x + lhs.s21 * rhs.y + lhs.s22 * rhs.z
  )
}

/// M * v where v is 1x3
@differentiable
public func matvec(transposed lhs: Matrix3, _ rhs: Vector3) -> Vector3 {
  return Vector3(
    lhs.s00 * rhs.x + lhs.s10 * rhs.y + lhs.s20 * rhs.z,
    lhs.s01 * rhs.x + lhs.s11 * rhs.y + lhs.s21 * rhs.z,
    lhs.s02 * rhs.x + lhs.s12 * rhs.y + lhs.s22 * rhs.z
  )
}

/// Returns the matrix-vector product of `lhs` and `rhs`.
@differentiable
public func matmul(_ lhs: Matrix3, _ rhs: Matrix3) -> Matrix3 {
  precondition(rhs.rowCount == lhs.columnCount)
  let v1 = matvec(lhs, Vector3(rhs.s00, rhs.s10, rhs.s20))
  let v2 = matvec(lhs, Vector3(rhs.s01, rhs.s11, rhs.s21))
  let v3 = matvec(lhs, Vector3(rhs.s02, rhs.s12, rhs.s22))
  
  return Matrix3(columns: v1, v2, v3)
}
