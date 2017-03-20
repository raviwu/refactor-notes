# 這裡說的 generalization 指的是 Class 層級的整理方式
# 方法其實和前面幾章大同小異

# 將特性上移到 SuperClass
# Pull Up Field (attribute)
# Pull Up Method
# Pull Up Constructor Body (initialize method)
# Extract Superclass

# 將非所有 Class 共享的特性下推到 SubClass
# Pull Down Field (attribute)
# Pull Down Method
# Extract New Subclass

# Extract Interface：類似 duck typing，把共同的 interface 抽成 module

# Collapse Hierarchy：除去不必要的物件繼承階層

# Form Templage Method：將 SuperClass 視為基礎範本，各 Subclass 若有不同實作則用複寫方式實作

# Delegation VS Hierarchy
# Replace Hierarchy with Delegation：如果某物件只使用部分的物件特徵，不需要繼承所有的物件特徵，可以傳入物件作為屬性之後，改用 delegation 的方式呼叫該屬性 instance 的函數。
# Raplcae Delegation with Hierarchy：假如發現 delegation 了引用屬性的「所有函式」，那麼應該改用繼承較為恰當。
