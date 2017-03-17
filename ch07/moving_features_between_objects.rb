# 決定物件的責任歸屬是「持續性」的活動，隨著產品功能的變遷，原先恰當的設計
# 可能變得不堪使用，透過「持續性」的重構來不斷平衡個物件的責任歸屬
#
# 通常 Move Method 跟 Move Field 就可以移轉物件行為，Move Field 會
# 優先於 Move Method 使用
#
# 當 Class 變得過於臃腫，可以先利用 Extract Class 把部分責任攤提出去
# 若是 Class 重構後變得「太不負責任」，便利用 Inline Class 的方式回轉
