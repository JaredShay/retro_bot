# The RequestParser takes a params hash and extracts it into the parts required
# to respond appropriately.
#
# These are:
#   Type - The type of request as determined by keywords. Options are:
#     write  - A response starting with a write keyword and required text.
#     read   - A response starting with a read keyword and optional text.
#     delete - A response starting with delete and optional text.
#     all    - A response starting with all and optional text.
#     help   - A any valid request with no known keyword.
#
#   Category - The keyword found in the response.
#
#   Item - The text a user intends to record.
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
    !!@text.match(/\Aretro\b.*\Z/)
  end

  def type
    @type ||= case @text
              when WRITE_REGEX    then :write
              when READ_REGEX     then :read
              when DELETE_REGEX   then :delete
              when LIST_ALL_REGEX then :all
              else                     :help
              end
  end

  def category
    @category ||= @text.split[1].chomp('s')
  end

  def item
    @item ||= @text.split[2..-1].join(' ')
  end
end
