//
//  BitArrayTests.swift
//  Buckets
//
//  Created by Mauricio Santos on 3/14/15.
//  Copyright (c) 2015 Mauricio Santos. All rights reserved.
//

import Foundation
import XCTest
import Buckets

class BitArrayTests: XCTestCase {
    
    struct TestData {
        static let Size = 40
        static let Cardinality = Size*2
        static let List: [Bool] = {
            var result = [Bool]()
            for i in 0..<Size {
                result += [true, false, false, true]
            }
            return result
        }()
    }
    
    var bArray = BitArray()
    
    
    func testEmptyArray() {
        XCTAssertEqual(bArray.count, 0)
        XCTAssertEqual(bArray.cardinality, 0)
        XCTAssertNil(bArray.first)
        XCTAssertNil(bArray.last)
    }
    
    func testInitWithRepeatedValue() {
        bArray = BitArray(count: TestData.Size, repeatedValue: true)
        XCTAssertEqual(bArray.count, TestData.Size)
        XCTAssertEqual(bArray.cardinality, TestData.Size)
        for i in 0..<TestData.Size {
            XCTAssertEqual(bArray[i], true)
        }
        bArray.append(false)
        XCTAssertEqual(bArray.count, TestData.Size + 1)
        XCTAssertEqual(bArray.last!, false)
    }
    
    func testSingleAppend() {
        bArray.append(true)
        XCTAssertEqual(bArray.count, 1)
        XCTAssertEqual(bArray.cardinality, 1)
        XCTAssertTrue(bArray.first != nil && bArray.first! == true)
        XCTAssertTrue(bArray.last != nil && bArray.last! == true)
    }
    
    func testConsecutiveAppends() {
        for i in TestData.List {
            bArray.append(i)
        }
        XCTAssertEqual(bArray.count, TestData.List.count)
        XCTAssertEqual(bArray.cardinality, TestData.Cardinality)
        for i in 0..<TestData.List.count {
            XCTAssertEqual(bArray[i], TestData.List[i])
        }
    }
    
    func testEmptyRemoveLast() {
        XCTAssertNil(bArray.removeLast())
        XCTAssertEqual(bArray.count, 0)
        XCTAssertEqual(bArray.cardinality, 0)
    }
    
    func testNonEmptyRemoveLast() {
        bArray = BitArray(TestData.List)
        
        let last = bArray.removeLast()
        XCTAssertTrue(last != nil && last == TestData.List.last!)
        XCTAssertEqual(bArray.count, TestData.List.count - 1)
        XCTAssertEqual(bArray.cardinality, TestData.Cardinality - 1)
        
        XCTAssertEqual(bArray.count, TestData.List.count - 1)
        for i in 0..<bArray.count {
            XCTAssertEqual(bArray[i], TestData.List[i])
        }
    }
    
    func testMultipleElementsInsertAtIndex() {
        // TODO: Split in multiple tests
        for i in 0...TestData.List.count {
                var list = TestData.List
                var array = BitArray(list)
                list.insert(true, atIndex: i)
                array.insert(true, atIndex: i)
                XCTAssertEqual(array.count, list.count)
                XCTAssertEqual(array.cardinality, cardinality(list))
                XCTAssertTrue(list.elementsEqual(array))
        }
    }
    
    func testEmptyInsertAtIndex() {
        bArray.insert(true, atIndex: 0)
        XCTAssertTrue(bArray.first != nil && bArray.first! == true)
    }
    
    func testMultipleElementsRemoveAtIndex() {
        for i in 0..<TestData.List.count {
            var list = TestData.List
            var array = BitArray(list)
            XCTAssertEqual(list.removeAtIndex(i), array.removeAtIndex(i))
            XCTAssertEqual(array.cardinality, cardinality(list))
            XCTAssertEqual(array.count, list.count)
            XCTAssertTrue(list.elementsEqual(array))
        }
    }
    
    func testSingleElementRemoveAtIndex() {
        bArray.append(true)
        XCTAssertEqual(bArray.removeAtIndex(0), true)
        XCTAssertNil(bArray.first)
    }
    
    func testRemoveAll() {
        bArray = BitArray(TestData.List)
        bArray.removeAll(keepCapacity: true)
        XCTAssertEqual(bArray.cardinality, 0)
        XCTAssertEqual(bArray.count, 0)
        XCTAssertNil(bArray.removeLast())
    }
    
    func testAppendAfterRemoveAll() {
        bArray = BitArray(TestData.List)
        bArray.removeAll(keepCapacity: true)
        bArray.append(true)
        XCTAssertEqual(bArray.cardinality, 1)
        XCTAssertTrue(bArray.first != nil && bArray.first! == true)
    }
    
    // MARK: SequenceType
    
    func testSequenceTypeConformance() {
        bArray = BitArray(TestData.List)
        XCTAssertTrue(bArray.elementsEqual(TestData.List))
    }
    
    // MARK: MutableCollectionType
    
    func testSubscriptGet() {
        let list = TestData.List
        bArray = BitArray(list)
        for i in 0..<bArray.count {
            XCTAssertEqual(bArray[i], list[i])
        }
        XCTAssertEqual(bArray[0], bArray.first!)
        XCTAssertEqual(bArray[bArray.count-1], bArray.last!)
    }
    
    func testSubscriptSet() {
        let reversedList = Array(TestData.List.reverse())
        bArray = BitArray(count: reversedList.count, repeatedValue: false)
        for i in 0..<reversedList.count {
            bArray[i] = reversedList[i]
            XCTAssertEqual(bArray[i], reversedList[i])
        }
    }
    
    func testArrayLiteralConvertibleConformance() {
        bArray = [true,false,true]
        XCTAssertTrue(bArray.elementsEqual([true,false,true]))
        XCTAssertEqual(bArray.cardinality, 2)
    }

    // MARK: Equatable
    
    func testEquatable() {
        bArray = []
        var other: BitArray = []
        XCTAssertTrue(bArray == other)
        bArray = [true]
        XCTAssertFalse(bArray == other)
        other.append(true)
        XCTAssertTrue(bArray == other)
    }
    
    
    // MARK: Helper methods
    
    private func cardinality(array: [Bool]) -> Int{
        var result = 0
        for value in array {
            if value {
                result += 1
            }
        }
        return result
    }
}
