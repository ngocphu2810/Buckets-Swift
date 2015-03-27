//
//  Stack.swift
//  Buckets
//
//  Created by Mauricio Santos on 2/19/15.
//  Copyright (c) 2015 Mauricio Santos. All rights reserved.
//

import Foundation

/// A Stack is a Last-In-First-Out (LIFO) collection,
/// the last element added to the stack will be the first one to be removed.
///
/// The `push` and `pop` operations run in amortized constant time.
/// Comforms to `SequenceType`, `ArrayLiteralConvertible`,
/// `Printable` and `DebugPrintable`.
public struct Stack<T> {

    // MARK: Properties
    
    /// Number of elements stored in the stack.
    public var count : Int {
        return elements.count
    }
    
    /// `true` if and only if `count == 0`.
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    /// The top element of the stack, or `nil` if the stack is empty.
    public var top: T? {
        return elements.last
    }
    
    private var elements = [T]()

    // MARK: Creating a Stack
    
    /// Constructs an empty stack of type `T`.
    public init() {}
    
    /// Constructs a stack from a standard array.
    /// The elements will be pushed from first to last.
    public init(elements: [T]) {
        self.elements = elements
    }
    
    // MARK: Adding and Removing Elements
    
    /// Inserts an element into the top of the stack.
    public mutating func push(element: T) {
        elements.append(element)
    }
    
    /// Retrieves and removes the top element of the stack.
    ///
    /// :returns: The top element, or `nil` if the stack is empty.
    public mutating func pop() -> T? {
        return !isEmpty ? elements.removeLast() : nil
    }
    
    /// Removes all the elements from the stack, and by default
    /// clears the underlying storage buffer.
    public mutating func removeAll(keepCapacity keep: Bool = true)  {
        elements.removeAll(keepCapacity:keep)
    }
}

// MARK: - SequenceType

extension Stack: SequenceType {
    
    // MARK: SequenceType Protocol Conformance
    
    /// Provides for-in loop functionality. Generates elements in LIFO order.
    ///
    /// :returns: A generator over the elements.
    public func generate() -> GeneratorOf<T> {
        var index = count - 1
        return GeneratorOf<T> {
            if index >= 0 {
                let value = self.elements[index]
                index--
                return value
            }
            return nil
        }
    }
}

// MARK: - ArrayLiteralConvertible

extension Stack: ArrayLiteralConvertible {
    
    // MARK: ArrayLiteralConvertible Protocol Conformance
    
    /// Constructs a stack using an array literal.
    /// The elements will be pushed from first to last.
    /// `let stack: Stack<Int> = [1,2,3]`
    public init(arrayLiteral elements: T...) {
        self.elements = elements
    }
}

// MARK: - Printable

extension Stack: Printable, DebugPrintable {
    
    // MARK: Printable Protocol Conformance
    
    /// A string containing a suitable textual
    /// representation of the stack.
    public var description: String {
        return "[" + join(", ", map(self) {"\($0)"}) + "]"
    }
    
    // MARK: DebugPrintable Protocol Conformance
    
    /// A string containing a suitable textual representation
    /// of the stack when debugging.
    public var debugDescription: String {
        return description
    }
}

// MARK: - Operators

// MARK: Stack Operators

/// Returns `true` if and only if the stacks contain the same elements
/// in the same order.
/// The underlying elements must conform to the `Equatable` protocol.
public func ==<U: Equatable>(lhs: Stack<U>, rhs: Stack<U>) -> Bool {
    return lhs.elements == rhs.elements
}

public func !=<U: Equatable>(lhs: Stack<U>, rhs: Stack<U>) -> Bool {
    return !(lhs == rhs)
}
