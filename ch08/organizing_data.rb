# 把資料變成會說話的物件：
# Replace Value with Object
# Change Value to Reference Object：例如 Currency 等不介意各副本單獨特性的資料類型
# Change Reference to Value Object：當 reference object 不堪使用時，改回 value object 的回頭路
# Replace Array with Object
#
# 避免使用 magic number：
# Replace Magic Number with Symbolic Constant
#
# 改變物件之間的連結關係：
# Change Unidirectional Association to Bidurectional
# Change Bidirectional Association to Unidirectional
#
# 封裝資料：
# Encapsulate Field
# Encapsulate Collection
# Encapsulate Record with Data Class
#
# 處理 Typecode
# - 如果 typecode 不影響 class 行為：Replace Typecode with Class
# - 如果 typecode 影響 class 行為：Replace Typecode with Subclasses 若
#   不能處理，可再利用 Replace Typecode with State/Strategy