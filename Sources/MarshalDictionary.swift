//
//  M A R S H A L
//
//       ()
//       /\
//  ()--'  '--()
//    `.    .'
//     / .. \
//    ()'  '()
//
//


import Foundation


// MARK: - Types

public typealias MarshalDictionary = [String: AnyObject]


// MARK: - Dictionary Extensions

extension Dictionary: MarshaledObject {
    public subscript(key: KeyType) -> Any? {
        guard let aKey = key as? Key else { return nil }
        
        return self[aKey]
    }
}

extension NSDictionary: MarshaledObject {
    public func anyForKey(key: KeyType) throws -> Any {
        let value:Any
        if key.dynamicType.keyTypeSeparator == "." {
            guard let v = self.valueForKeyPath(key.stringValue) else {
                throw Error.KeyNotFound(key: key)
            }
            value = v
        }
        else {
            let pathComponents = key.split()
            var accumulator: Any = self

            for component in pathComponents {
                if let componentData = accumulator as? MarshaledObject, v = componentData[component] {
                    accumulator = v
                    continue
                }
                throw Error.KeyNotFound(key: key.stringValue)
            }
            value = accumulator
        }

        if let _ = value as? NSNull {
            throw Error.NullValue(key: key)
        }

        return value
    }

    public subscript(key: KeyType) -> Any? {
        guard let aKey = key as? Key else { return nil }
        
        return self[aKey]
    }
}
