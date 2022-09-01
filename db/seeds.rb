# ============ init Section, Node ================
%w[甜苹果 酸葡萄 直通车 Life Market 其他].each do |name|
  Node.create!(name: name, summary: "...")
end
