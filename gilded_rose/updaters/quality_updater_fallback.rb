class QualityUpdaterFallback
  def matches(_item)
    true
  end

  def update(item)
    item.sell_in -= 1
    item.quality -= item_expired?(item) ? 2 : 1
  end

  private

  def item_expired?(item)
    item.sell_in < 0
  end
end
