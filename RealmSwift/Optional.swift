////////////////////////////////////////////////////////////////////////////
//
// Copyright 2015 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import Realm

#if swift(>=3.0)

/// Types that can be represented in a `RealmOptional`.
public protocol RealmOptionalType {
    // Must conform to ObjectiveCBridgeable
}
extension Int: RealmOptionalType {}
extension Int8: RealmOptionalType {}
extension Int16: RealmOptionalType {}
extension Int32: RealmOptionalType {}
extension Int64: RealmOptionalType {}
extension Float: RealmOptionalType {}
extension Double: RealmOptionalType {}
extension Bool: RealmOptionalType {}
extension RealmOptionalType {
    internal static func bridging(objCValue value: Any) -> Self {
        return (Self.self as! ObjectiveCBridgeable.Type).bridging(objCValue: value) as! Self
    }
    var objCValue: Any {
        return (self as! ObjectiveCBridgeable).objCValue
    }
}

/**
A `RealmOptional` represents a optional value for types that can't be directly
declared as `dynamic` in Swift, such as `Int`s, `Float`, `Double`, and `Bool`.

It encapsulates a value in its `value` property, which is the only way to mutate
a `RealmOptional` property on an `Object`.
*/
public final class RealmOptional<T: RealmOptionalType>: RLMOptionalBase {
    /// The value this optional represents.
    public var value: T? {
        get {
            return underlyingValue.map(T.bridging)
        }
        set {
            underlyingValue = newValue.map({ $0.objCValue })
        }
    }

    /**
    Creates a `RealmOptional` with the given default value (defaults to `nil`).

    - parameter value: The default value for this optional.
    */
    public init(_ value: T? = nil) {
        super.init()
        self.value = value
    }
}

#else

/// A protocol describing types that can parameterize a `RealmOptional`.
public protocol RealmOptionalType {
    // Must conform to ObjectiveCBridgeable
}
extension Int: RealmOptionalType {}
extension Int8: RealmOptionalType {}
extension Int16: RealmOptionalType {}
extension Int32: RealmOptionalType {}
extension Int64: RealmOptionalType {}
extension Float: RealmOptionalType {}
extension Double: RealmOptionalType {}
extension Bool: RealmOptionalType {}
extension RealmOptionalType {
    internal static func bridging(objCValue objCValue: AnyObject) -> Self {
        return (Self.self as! ObjectiveCBridgeable.Type).bridging(objCValue: objCValue) as! Self
    }
    var objCValue: AnyObject {
        return (self as! ObjectiveCBridgeable).objCValue
    }
}

/**
 A `RealmOptional` instance represents a optional value for types that can't be directly declared as `dynamic` in Swift,
 such as `Int`, `Float`, `Double`, and `Bool`.

 To change the underlying value stored by a `RealmOptional` instance, mutate the instance's `value` property.
*/
public final class RealmOptional<T: RealmOptionalType>: RLMOptionalBase {
    /// The value this optional represents.
    public var value: T? {
        get {
            return underlyingValue.map(T.bridging)
        }
        set {
            underlyingValue = newValue.map({ $0.objCValue })
        }
    }

    /**
     Creates a `RealmOptional` instance encapsulating the given default value.

     - parameter value: The value to store in the optional, or `nil` if not specified.
     */
    public init(_ value: T? = nil) {
        super.init()
        self.value = value
    }
}

#endif
