# Rename Method：使用更貼切的名稱形容函數行為
#
# 調整參數的使用：
# - Add Parameter
# - Remove Parameter
# - Preserve Whole Object：傳入整個物件以減少參數數目
# - Introduce Parameter Object：與其每次都必須傳入 start_date / end_date，不如傳入一個 DateRange 物件
# - Replace Parameter with Method：當傳入參數為自身也能呼叫的函數結果時，無須使用參數方式傳入
# - Replace Parameter with Explicit Method：取代那些被用來當條件篩選的參數
# - Parameterize Method：替數個函數傳遞參數

# Remove Setting Method：當屬性被初始化後就無法改變，則應避免提供 attr_writer 介面
# Hide Method：當 method 非公開介面時，應宣告為 private method

# 不要將 modifiers 函數和 queries 函數混在一起：
# Separate Query from Modifier

# Parameterize Method
# ==========================================

class Employee
  def ten_percent_raise
    salary * 1.1
  end

  def five_percent_raise
    salary * 1.05
  end
end

# change into >>

class Employee
  def raise(percentage)
    salary * (100 + percentage) / 100.0
  end
end

# Replace Parameter with Explicit Methods
# ==========================================

class Shape
  def set_value(attribute, value)
    case attribute
    when :height then @height = value
    when :width then @width = value
    else raise "Invalid attribute: #{attribute}"
    end
  end
end

# change into >>

class Shape
  def height=(value)
    @height = value
  end

  def width=(value)
    @width = value
  end
end