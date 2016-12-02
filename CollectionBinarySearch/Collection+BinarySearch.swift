import Foundation

public extension Collection
  where
  Iterator.Element: Comparable,
  Iterator.Element: Equatable,
  IndexDistance == Index,
  Index: SignedInteger
{
  /// Find index of equatable element using binary search.
  ///
  /// - Parameters:
  ///   - element: Object to find
  ///   - option: Find lower bound (firstEqual), upper bound (lastEqual),
  /// or "normal" index with insertionIndex
  /// - Returns: Found index or nil
  func binarySearchIndex(
    of element: Self.Iterator.Element,
    option: NSBinarySearchingOptions = NSBinarySearchingOptions.insertionIndex) -> Index?
  {
    return binarySearchIndex(
      with: option,
      equality: { $0 == element },
      greaterThan: { $0 > element },
      lessThan: { $0 < element }
    )
  }

  /// Binary search using custom comparator closures.
  ///
  /// - Parameters:
  ///   - option: Find lower bound (firstEqual), upper bound (lastEqual),
  /// or "normal" index with insertionIndex
  ///   - equality: Equality test closure
  ///   - greaterThan: greaterThan test closure
  ///   - lessThan: lessThan test closure
  /// - Returns: Found index or nil
  func binarySearchIndex(
    with option: NSBinarySearchingOptions = NSBinarySearchingOptions.insertionIndex,
    equality: (Self.Iterator.Element) -> Bool,
    greaterThan: (Self.Iterator.Element) -> Bool,
    lessThan: (Self.Iterator.Element) -> Bool
    ) -> Index?
  {
    if option == NSBinarySearchingOptions.insertionIndex {
      return indexOfInsertion(equality: equality, greaterThan: greaterThan, lessThan: lessThan)
    } else {
      return indexOfBoundedObject(option, equality: equality, greaterThan: greaterThan)
    }
  }
}

public extension RangeReplaceableCollection
  where
  Iterator.Element: Comparable,
  Iterator.Element: Equatable,
  IndexDistance == Index,
  Index: SignedInteger
{
  /// Insert an element into a `RangeReplaceableCollection` at
  /// the sorted index point.
  ///
  /// - Parameter element: Item to insert
  /// - Returns: Index where inserted
  @discardableResult
  mutating func insertAtSorted(_ element: Iterator.Element) -> Index {
    let index = indexOfInsertion(element)
    insert(element, at: index)
    return index
  }
}

fileprivate extension Collection
  where
  Iterator.Element: Comparable,
  Iterator.Element: Equatable,
  IndexDistance == Index,
  Index: SignedInteger
{
  func indexOfBoundedObject(
    _ element: Self.Iterator.Element,
    option: NSBinarySearchingOptions = NSBinarySearchingOptions.firstEqual
    ) -> Index?
  {
    return indexOfBoundedObject(option, equality: { $0 == element }, greaterThan: { $0 > element })
  }

  func indexOfInsertion(_ element: Self.Iterator.Element) -> Index {
    return indexOfInsertion(
      equality: { $0 == element },
      greaterThan: { $0 > element },
      lessThan: { $0 < element }
    )
  }

  func indexOfBoundedObject(
    _ option: NSBinarySearchingOptions = NSBinarySearchingOptions.firstEqual,
    equality: (Self.Iterator.Element) -> Bool,
    greaterThan: (Self.Iterator.Element) -> Bool
    ) -> Index?
  {
    var lo = self.startIndex
    var hi = self.endIndex
    var best: Index?

    while lo <= hi {
      let mid = (hi - lo) / 2 + lo

      if mid >= count {
        break
      }

      if equality(self[mid]) {
        best = mid

        switch option {
        case NSBinarySearchingOptions.firstEqual:
          // try lower
          hi = mid - 1
        case NSBinarySearchingOptions.lastEqual:
          // try higher
          lo = mid + 1
        default:
          break
        }
      } else if greaterThan(self[mid]) {
        // try lower
        hi = mid - 1
      } else {
        // try higher
        lo = mid + 1
      }
    }

    return best
  }

  func indexOfInsertion(
    equality: (Self.Iterator.Element) -> Bool,
    greaterThan: (Self.Iterator.Element) -> Bool,
    lessThan: (Self.Iterator.Element) -> Bool
    ) -> Index
  {
    guard count > 0 else {
      return self.startIndex
    }

    var lo: Index = self.startIndex
    var hi: Index = self.endIndex
    var mid: Index = self.startIndex

    while lo < hi {
      mid = (hi - lo) / 2 + lo
      let val = self[mid]

      if equality(val) {
        return mid
      } else if greaterThan(val) {
        // search low
        hi = mid
      } else {
        // search hi
        lo = mid + 1
      }
    }

    return lessThan(self[mid]) ? mid + 1 : mid
  }
}
