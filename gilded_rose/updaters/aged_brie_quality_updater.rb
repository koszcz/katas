class AgedBrieQualityUpdater
  def matches(item)
    item.name == 'Aged Brie'
  end

  def update(item)
    item.quality += 1
    item.sell_in -= 1
  end
end
