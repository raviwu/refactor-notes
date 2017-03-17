# 許多程式問題來自過大的 method
# 對付過長 method 的手段：
# - Extract Method：把其中一段邏輯獨立抽出
# - Inline Method：如果發現 Extract 出來的函數並沒有多做特別的事情需要封裝，可以再把 Extracted Method 塞回去原本的地方
#
# 處理暫時變數的手段：
# - Split Temporary Variable：先把暫時變數變得容易置換
# - Replace Temp with Query
# - Replace Method with Method Object：透過加入 Class 來抽出 Method
# - Remove Assignments to Parameters：不要在函數內對於輸入的參數進行賦值
#
# 整理完函數後：
# - Substitute Algorithm：置換成更有效率的演算法來改進函數

# Extract Method
# ===========================

def test_statement_empty_rental
  customer = Customer.new(name: 'Ravi Wu')
  expected_statement =
    "Rental Record for Ravi Wu\n" +
    "Amount owed is 0\n" +
    "You earned 0 frequent renter points."

  assert_equal(expected_statement, customer.statement)
end

def test_statement_regular_rental_within_2_days
  customer = Customer.new(name: 'Ravi Wu')
  customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

  expected_statement =
    "Rental Record for Ravi Wu\n" +
    "\tse7en\t2\n" +
    "Amount owed is 2\n" +
    "You earned 1 frequent renter points."

  assert_equal(expected_statement, customer.statement)
end

# ------------

def test_statement_empty_rental
  customer = Customer.new(name: 'Ravi Wu')
  expected_statement =
    header(customer.name) +
    footer(total: 0, renter_point: 0)

  assert_equal(expected_statement, customer.statement)
end

def test_statement_regular_rental_within_2_days
  customer = Customer.new(name: 'Ravi Wu')
  customer.add_rental(Rental.new(movie: @movie_seven, days_rented: 2))

  expected_statement =
    header(customer.name) +
    line_item(@movie_seven.title => 2.0) +
    footer(total: 2.0, renter_point: 1)

  assert_equal(expected_statement, customer.statement)
end

def header(name)
  "Rental Record for #{name}\n"
end

def footer(total:, renter_point:)
  "Amount owed is #{total}\n" +
  "You earned #{renter_point} frequent renter points."
end

def line_item(rentals)
  rentals.map do |title, amount|
    "\t#{title}\t#{amount}\n"
  end.join
end

# Inline Method
# ===========================
# - 有時候函數內容跟函數名稱一樣具有清晰的可讀性也很簡短，便可以移掉非必要的間接性
# - 在複雜的函數中，如果要移動一塊裡面又呼叫了其他函數的邏輯，事情會變得較為複雜，可以先把要抽出來的地方 Inline 回去後減少相依再一起抽出
# - 使用太多間接層後造成閱讀與理解程式邏輯的困難，可以先用 Inline Method 消除非必要的間接層再重新 Extract

# Replace Temp with Query
# ===========================

def discount_price
  base_price = quantity * unit_price
  base_price > 1000 ? base_price * 0.95 : base_price * 0.98
end

# ------------

def discount_price
  base_price > 1000 ? base_price * 0.95 : base_price * 0.98
end

def base_price
  quantity * unit_price
end

# Introducing Explaining Variable
# ===========================
# 一般來說可以直接用 Extract Method 來做，但如果函數複雜較不好實施 Extract Method 時也可以導入具可讀性變數的方式提高函數品質

def setup
  do_somthing if platform.upcase.include?('MAC') &&
    browser.upcase.include?('IE') &&
    was_initialized? && resize > 0
end

# ------------

def setup
  is_mac_os? = platform.upcase.include?('MAC')
  is_ie_browser? = browser.upcase.include?('IE')
  was_resized? = resize > 0

  do_somthing if is_mac_os? && is_ie_browser? && was_initialized? && was_resized?
end

# Split Temporary Variable
# ===========================
# 當一個非迴圈變數或迨疊變數的區域變數被重複賦值，應該針對每次賦值建立單獨的變數，減少變數相依

def calculate
  temp = 2 * (height + width)
  puts temp

  temp = height * width
  puts temp
end

# ------------

def calculate
  perimeter = 2 * (height + width)
  puts perimeter

  area = height * width
  puts area
end

# Remove Assignments to Parameters
# ===========================
# 當函數對於參數賦值時，以暫時變數代替重新被賦值的參數，避免 pass by value / pass by reference 造成的問題

def do_somthing(foo)
  foo.make_some_change! # that's ok
  foo = another_bar # that's bad
end

# Replace Method with Method Object
# ===========================
# 把函數放到 Class 裡，可以讓區域變數變成物件的欄位，例如 Ch01 的 Price objects
