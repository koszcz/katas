class GildedRose
  def initialize(items, max_quality = 50)
    @items = items
    @max_quality = max_quality
    @updaters = [
      SulfurasQualityUpdater.new,
      AgedBrieQualityUpdater.new,
      BackstageQualityUpdater.new,
      DefaultQualityUpdater.new
    ]
  end

  def update_quality
    @items.each { |item| update_quality_for_item(item) }
  end

  private

  def update_quality_for_item(item)
    @updaters.each do |updater|
      next unless updater.matches(item)

      updater.update(item)
      post_validations(item)
      return
    end
  end

  def post_validations(item)
    item.quality = value_between(item.quality, 0, @max_quality)
  end

  def value_between(value, min, max)
    [[value, min].max, max].min
  end
end

class DefaultQualityUpdater
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

class SulfurasQualityUpdater
  def matches(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def update(item); end
end

class AgedBrieQualityUpdater
  def matches(item)
    item.name == 'Aged Brie'
  end

  def update(item)
    item.quality += 1
    item.sell_in -= 1
  end
end

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

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
