/** streamlines multi-step initialization and configuration processes
 - Parameters:
     - value: initial value
     - block: configures the value
     - Parameters:
     - object: to configure and return


 [NSHipster blog post](https://nshipster.com/new-years-2016/#easier-configuration)
*/
public func Init<Type>(value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}
