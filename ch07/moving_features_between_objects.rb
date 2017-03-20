# 決定物件的責任歸屬是「持續性」的活動，隨著產品功能的變遷，原先恰當的設計
# 可能變得不堪使用，透過「持續性」的重構來不斷平衡個物件的責任歸屬
#
# 通常 Move Method 跟 Move Field 就可以移轉物件行為，Move Field 會
# 優先於 Move Method 使用
#
# 當 Class 變得過於臃腫，可以先利用 Extract Class 把部分責任攤提出去
# 若是 Class 重構後變得「太不負責任」，便利用 Inline Class 的方式回轉
#
# 使用 Hide Delegate 把 Class 相依性隱藏有時會是不錯的方式，但如果介面
# 經常變化造成困擾，可以使用 Remove Middle Man 來重新揭露 Hidden Delegation
#
# 當不能存取某個 Class 但又想把其他責任一到這個 Class 時，可以使用：
# Introduce Foreign Method：小規模地新增 method
# Introduce Local Extension：較大規模地新增 method

# Move Method
# ===========================
# 當 class 中有 method 和另一個 class 的互動多餘本來的 class 時

class Account
  attr_reader :account_type, :days_overdrawn

  def overdraft_charge
    if account_type.is_premium?
      days_overdrawn > 7 ? (10 + (days_overdrawn - 7) * 0.85) : 10
    else
      days_overdrawn * 1.75
    end
  end

  def bank_charge
    days_overdrawn > 0 ? (4.5 + overdraft_charge) : 4.5
  end
end

# --------------------------

class AccountType
  def overdraft_charge(days_overdrawn)
    if is_premium?
      days_overdrawn > 7 ? (10 + (days_overdrawn - 7) * 0.85) : 10
    else
      days_overdrawn * 1.75
    end
  end
end

class Account
  attr_reader :account_type, :days_overdrawn

  def overdraft_charge
    account_type.overdraft_charge(days_overdrawn)
  end

  def bank_charge
    result = 4.5
    result += overdraft_charge if days_overdrawn > 0
    result
  end
end

# Move Field (Move Attribute)
# ===========================
# 當 class 中有 attribute 和另一個 class 的互動多餘本來的 class 時

class Account
  attr_reader :account_type, :interest_rate

  def interest_rate_for_amount(amount, days)
    interest_rate * amount * days / 365
  end
end

# --------------------------

class AccountType
  attr_reader :interest_rate
end

class Account
  attr_reader :account_type

  def interest_rate_for_amount(amount, days)
    account_type.interest_rate * amount * days / 365
  end
end

# with self-encapsulation
# --------------------------

class AccountType
  attr_reader :interest_rate

  def interest_rate_for_amount(amount, days)
    interest_rate * amount * days / 365
  end 
end

class Account
  attr_reader :account_type

  def interest_rate_for_amount(amount, days)
    account_type.interest_rate_for_amount(amount, days)
  end
end

# Extract Class
# ===========================
# 當 class 中承擔應該由兩個 class 以上承擔的責任時
# - subtyping 只影響 class 的部分特性
# - 某些特性需要以某特定方式 subtyping

# Inline Class
# ===========================
# 當 class 承擔責任過少時，不再有顯而易見獨立存在的理由時
