class RequestParser
  WRITE_REGEX    = /\Aretro\s+(positive|negative|question|change)\s+.+/
  READ_REGEX     = /\Aretro\s+(positives|negatives|questions|changes)\s*/
  LIST_ALL_REGEX = /\Aretro\s+all\s*/
  DELETE_REGEX   = /\Aretro\s+delete\s*/

  def self.parse(params)
    new(params)
  end

  attr_reader :user

  def initialize(params)
    @text = params.fetch('text')
    @user = params.fetch('user_name')
  end

  def valid?
    !!@text.match(/\Aretro/)
  end

  def type
    @type ||= case @text
              when WRITE_REGEX    then :write
              when READ_REGEX     then :read
              when DELETE_REGEX   then :delete
              when LIST_ALL_REGEX then :all
              else                   :help
              end
  end

  def category
    @category ||= @text.split[1].chomp('s')
  end

  def item
    @item ||= @text.split[2..-1].join(' ')
  end
end
