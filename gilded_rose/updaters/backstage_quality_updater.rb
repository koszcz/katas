class BackstageQualityUpdater
  def matches(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def update(item)
    item.sell_in -= 1

    if item.sell_in < 0
      item.quality = 0
    else
      item.quality += 1
      item.quality += 1 if item.sell_in < 11
      item.quality += 1 if item.sell_in < 6
    end
  end
end
