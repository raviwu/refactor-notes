# 如果程式碼的多處測試有相同結果
# Consolidate Conditional Expression
#
# 如果條件式中有重複
# Consolidate Duplicate Conditional Fragments

# 減少過濾特殊狀況而產生的多層條件式：
# Replace Nested Conditional with Guard Clauses

# 減少 nil check
# Introduce Null Object

# Decompose Conditional
# ==================================

if date.before(SUMMER_START) || date.after(SUMMER_END)
  charge = quantity * winter_rate + winter_service_charge
else
  charge = quantity * summer_rate
end

# change into >>

if not_summer(date)
  charge = winter_charge(quantity)
else
  charge = summer_charge(quantity)
end

# Consolidate Conditional Expression
# ==================================

def disability_amount
  return 0 if seniority < 2
  return 0 if months_disabled > 12
  return 0 if is_part_time?
end

# change into >>

def disability_amount
  return 0 if is_not_eligable_for_disability?
end

def is_not_eligable_for_disability?
  seniority < 2 || months_disabled > 12 || is_part_time?
end

# Consolidate Duplicate Conditional Fragments
# ==================================

def consolidate_duplicate_conditional
  if is_special_deal
    total = price * 0.95
    send_email
  else
    total = price * 0.98
    send_email
  end
end

# change into >>

def consolidate_duplicate_conditional
  total = 
    if is_special_deal
      price * 0.95
    else
      price * 0.98
    end

  send_email
end
