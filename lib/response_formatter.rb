# The ResponseFormatter is responsibile for formatting all output
class ResponseFormatter
  def self.help_text
    "*Usage:*" +
    "\n\t- retro <positive|negative|change|question>: _add a retro item_" +
    "\n\t- retro <positives|negatives|changes|questions>: _list retro items_" +
    "\n\t- retro all: _list all retro items_" +
    "\n\t- retro delete: _delete all retro items_"
  end

  def self.write_confirmation_text(user:, category:, item:)
    "_#{user} added a #{category} item_ - #{item}"
  end

  def self.read_items(items:, category:)
    if items.empty?
      "There are no #{category} items"
    else
    "*#{category.to_s.capitalize}s:*\n\t- #{items.join("\n\t- ")}"
    end
  end

  def self.list_all_items(items:)
    if items.empty?
      'There are no retro items'
    else
      all_items(items)
    end
  end

  def self.delete_all_items(items:)
    "*All items deleted*\n" + all_items(items)
  end

  def self.all_items(items)
    response = ""

    [:positive, :negative, :question, :change].each do |category|
      if !items[category].empty?
        response += "\n#{category}s:"
        items[category].each do |item|
          response += "\n\t- _#{item}_"
        end
      end
    end

    response
  end
end
