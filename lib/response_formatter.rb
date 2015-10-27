class ResponseFormatter
  def self.help_text
    "*Usage:*" +
    "\n\t- retro <positive|negative|change|question>: _add a retro item_" +
    "\n\t- retro <positives|negatives|changes|questions>: _list retro items_" +
    "\n\t- retro delete: _delete all retro items_"
  end

  def self.write_confirmation_text(user:, category:, item:)
    "_#{user} added a #{category} item_ - #{item}"
  end

  def self.read_items(items:, category:)
    if items.empty?
      "There are no #{category} items"
    else
    "#{category} items: \n\t- #{items.join("\n\t- ")}"
    end
  end

  def self.all_items(items:)
    response = "*All items deleted*\n"

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
