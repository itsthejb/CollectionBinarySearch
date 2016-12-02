import Foundation

public extension Collection
  where
  Iterator.Element: Comparable,
  Iterator.Element: Equatable,
  IndexDistance == Index,
  Index: SignedInteger
{
  typealias Comparator = (Self.Iterator.Element) -> Bool

  func binarySearchIndex(
    of object: Self.Iterator.Element,
    option: NSBinarySearchingOptions = NSBinarySearchingOptions.firstEqual) -> Index?
  {
    return binarySearchIndex(equality: { $0 == object }, greaterThan: { $0 > object }, lessThan: { $0 < object })
  }

  func binarySearchIndex(
    with option: NSBinarySearchingOptions = NSBinarySearchingOptions.firstEqual,
    equality: Comparator,
    greaterThan: Comparator,
    lessThan: Comparator
    ) -> Index?
  {
    if option == NSBinarySearchingOptions.insertionIndex {
      return indexOfInsertion(equality, greaterThan: greaterThan, lessThan: lessThan)
    } else {
      return indexOfBoundedObject(option, equality: equality, greaterThan: greaterThan)
    }
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
    _ object: Self.Iterator.Element,
    option: NSBinarySearchingOptions = NSBinarySearchingOptions.firstEqual
    ) -> Index?
  {
    return indexOfBoundedObject(option, equality: { $0 == object }, greaterThan: { $0 > object })
  }

  func indexOfInsertion(_ object: Self.Iterator.Element) -> Index {
    return indexOfInsertion({ $0 == object }, greaterThan: { $0 > object }, lessThan: { $0 < object })
  }

  func indexOfBoundedObject(
    _ option: NSBinarySearchingOptions = NSBinarySearchingOptions.firstEqual,
    equality: Comparator,
    greaterThan: Comparator
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
    _ equality: Comparator,
    greaterThan: Comparator,
    lessThan: Comparator
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
      }
      else if greaterThan(val) {
        // search low
        hi = mid
      }
      else {
        // search hi
        lo = mid + 1
      }
    }

    return lessThan(self[mid]) ? mid + 1 : mid
  }
}

public extension RangeReplaceableCollection
  where
  Iterator.Element: Comparable,
  Iterator.Element: Equatable,
  IndexDistance == Index,
  Index: SignedInteger
{
  @discardableResult
  mutating func insertAtSorted(_ object: Iterator.Element) -> Index {
    let index = indexOfInsertion(object)
    insert(object, at: index)
    return index
  }
}
