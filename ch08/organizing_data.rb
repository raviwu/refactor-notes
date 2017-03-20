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

# Replace Type Code with Subclasses
# =========================================

class Employee
  ENGINEER = 0
  SALESMAN = 1
  MANAGER = 3

  def create(type)
    case type
    when ENGINEER then Engineer.new
    when SALESMAN then Salesman.new
    when MANAGER then Manager.new
    else raise 'Invalid Type Code'
    end
  end
end

class Engineer < Employee
  def type
    Employee::ENGINEER
  end
end

class Salesman < Employee
  def type
    Employee::SALESMAN
  end
end

class Manager < Employee
  def type
    Employee::MANAGER
  end
end

# Replace Type Code with State/Strategy
# =========================================
# 新增一個 class 把狀態封存成單一的 switch 準備好往下繼續拆 Replace Conditional with Polymorphism

class Employee
  attr_reader :type

  ENGINEER = 0
  SALESMAN = 1
  MANAGER = 3

  def initialize(type)
    @type = type
  end

  def pay_amount
    case type
    when ENGINEER then monthly_salary
    when SALESMAN then monthly_salary + commission
    when MANAGER then monthly_salary + bonus
    else raise 'Invalid Employee'
    end
  end
end

# -----------------------------------------

class Employee
  attr_reader :employee_type

  def initialize(type)
    @employee_type = EmployeeType.new(type)
  end

  def pay_amount
    case employee_type.type
    when EmployeeType::ENGINEER then monthly_salary
    when EmployeeType::SALESMAN then monthly_salary + commission
    when EmployeeType::MANAGER then monthly_salary + bonus
    else raise 'Invalid Employee'
    end
  end

  #...
end

class EmployeeType
  ENGINEER = 0
  SALESMAN = 1
  MANAGER = 3

  def initialize(type)
    case type
    when ENGINEER then Engineer.new
    when SALESMAN then Salesman.new
    when MANAGER then Manager.new
    else raise 'Invalid Employee'
    end
  end
end

class Engineer < EmployeeType
  def type
    Employee::ENGINEER
  end
end

class Salesman < EmployeeType
  def type
    Employee::SALESMAN
  end
end

class Manager < EmployeeType
  def type
    Employee::MANAGER
  end
end

# -----------------------------------------

class Employee
  attr_reader :employee_type

  def initialize(type)
    @employee_type = EmployeeType.new(type)
  end

  def pay_amount
    employee_type.pay_amount
  end

  #...
end

class EmployeeType
  ENGINEER = 0
  SALESMAN = 1
  MANAGER = 3

  def initialize(type)
    case type
    when ENGINEER then Engineer.new
    when SALESMAN then Salesman.new
    when MANAGER then Manager.new
    else raise 'Invalid Employee'
    end
  end
end

class Engineer < EmployeeType
  def type
    Employee::ENGINEER
  end

  def pay_amount
    monthly_salary
  end
end

class Salesman < EmployeeType
  def type
    Employee::SALESMAN
  end

  def pay_amount
    monthly_salary + commission
  end
end

class Manager < EmployeeType
  def type
    Employee::MANAGER
  end

  def pay_amount
    monthly_salary + bonus
  end
end
