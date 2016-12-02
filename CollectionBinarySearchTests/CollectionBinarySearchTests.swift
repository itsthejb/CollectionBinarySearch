//
//  CollectionBinarySearchTests.swift
//  CollectionBinarySearchTests
//
//  Created by Jonathan Crooke on 02/12/2016.
//  Copyright © 2016 Jonathan Crooke. All rights reserved.
//

import XCTest
import CollectionBinarySearch

final class CollectionBinarySearchTests: XCTestCase {
  typealias Value = UInt32
  var a: [Value]!

  struct Constants {
    static let maxSize: Value = 512
    static let maxValue: Value = 1024
    static let iterations: Value = 512
  }

  func generate() -> [Value] {
    return (0..<arc4random_uniform(Constants.maxSize)).reduce([Value]()) {
      var a = $0.0
      a.insertAtSorted(arc4random_uniform(Constants.maxValue))
      return a
    }
  }

  override func setUp() {
    super.setUp()
    a = generate()
  }

  func testInsertionSort() {
    measure {
      for _ in 0..<Constants.iterations {
        for i in 0..<max(0, self.a.count - 1) {
          XCTAssertLessThanOrEqual(self.a[i], self.a[i + 1])
        }
        self.a = self.generate()
      }
    }
  }

  func testBinarySearch() {
    measure {
      for _ in 0..<Constants.iterations {
        for _ in 0..<max(0, self.a.count - 1) {
          let expected = Int(arc4random_uniform(UInt32(self.a.count - 1)))
          let actual = self.a.binarySearchIndex(of: self.a[expected])!
          XCTAssertEqual(self.a[expected], self.a[actual])
        }
        self.a = self.generate()
      }
    }
  }
}
