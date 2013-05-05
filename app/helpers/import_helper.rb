module ImportHelper
  # a helper caching class that writes and stores to a file
  class MiniFileStorage
    def initialize(path, storage = {})
      @storage = storage
      @path = path
    end

    def load
      if @storage.length == 0 && File.exists?(@path)
        data = File.open(@path, 'rb') { |f| f.read }
        @storage = Marshal.load data
      end
      @storage
    end

    def write(data)
      @storage = data
      File.open(@path, 'wb') do |fh|
        fh.flock(File::LOCK_EX)
        fh.write(Marshal.dump(@storage))
      end
    end
  end


end
