# The ResponseFormatter is responsibile for formatting all output
class ResponseFormatter
  def self.help_text
    "*Usage:*" +
    "\n\t- retro <positive|negative|change|question>: _add a items_" +
    "\n\t- retro <positives|negatives|changes|questions>: _list items_" +
    "\n\t- retro all: _list all items_" +
    "\n\t- retro help: _display help text_" +
    "\n\t- retro delete: _delete all items_"
  end

  def self.write_confirmation_text(user:, category:, item:)
    "_#{user} added a #{category} item_ - #{item}"
  end

  def self.read_items(items:, category:)
    items.empty? ? "There are no #{category}s" : items_for(items, category)
  end

  def self.list_all_items(items:)
    return 'There are no retro items' if items.all? { |_, v| v.empty? }

    all_items(items)
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

  def self.items_for(items, category)
    "*#{category.to_s.capitalize}s:*\n\t- #{items.join("\n\t- ")}"
  end
end
