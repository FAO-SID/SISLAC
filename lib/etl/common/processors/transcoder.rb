# Utility class for detecting source encoding and enforcing utf-8, saving the
# transcoded contents on `destination`. Clients must ensure they close and
# unlink this temporary file.

require 'charlock_holmes'
require 'tempfile'

class Transcoder
  attr_accessor :file, :content, :detection, :destination

  def initialize(file)
    @file = file
    @content = File.read(file)
    @detection = CharlockHolmes::EncodingDetector.detect(content)
    @destination = Tempfile.new('transcoding_user_csv')
  end

  def transcode!
    # FIXME Do it in batches for large files
    destination.write CharlockHolmes::Converter.convert(content, detection[:encoding], 'UTF-8')

    destination.rewind && destination
  end
end
