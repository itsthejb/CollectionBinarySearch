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
  var array: [Value]!

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

  func testInsertionSort() {
    measure {
      for _ in 0..<Constants.iterations {
        self.array = self.generate()

        for i in 0..<max(0, self.array.count - 1) {
          XCTAssertLessThanOrEqual(self.array[i], self.array[i + 1])
        }
      }
    }
  }

  func testBinarySearch() {
    measure {
      for _ in 0..<Constants.iterations {
        self.array = self.generate()

        for _ in 0..<max(0, self.array.count - 1) {
          let expected = Int(arc4random_uniform(UInt32(self.array.count - 1)))
          let actual = self.array.binarySearchIndex(of: self.array[expected])!
          XCTAssertEqual(self.array[expected], self.array[actual])
        }
      }
    }
  }

  func testEmpty() {
    XCTAssertNil([].binarySearchIndex(of: 5, option: .firstEqual))
  }

  func testFirstEqual() {
    XCTAssertEqual([5, 5, 5, 5, 5].binarySearchIndex(of: 5, option: .firstEqual), 0)
  }

  func testLastEqual() {
    XCTAssertEqual([5, 5, 5, 5, 5].binarySearchIndex(of: 5, option: .lastEqual), 4)
  }

  func testInsertionPointShouldInsertInMiddle() {
    XCTAssertEqual([5, 5, 5, 5, 5].binarySearchIndex(of: 5, option: .insertionIndex), 2)
  }

  func testHandlesNotFoundLow() {
    XCTAssertNil([5, 6, 7, 8, 9].binarySearchIndex(of: 4, option: .firstEqual))
  }

  func testHandlesNotFoundHigh() {
    XCTAssertNil([5, 6, 7, 8, 9].binarySearchIndex(of: 10, option: .firstEqual))
  }
}
