require 'find'
require 'pathname'
require 'set'

require_relative 'config.rb'

module Keep
  def self.fetch_results(query)
    dir = config.home
    if query[-1] == File::SEPARATOR
      dir, query = File.join(dir, query), ''
    elsif query.include?(File::SEPARATOR)
      subdir, query = File.split(query)
      dir = File.join(dir, subdir)
    end
    query.empty? ? list_notes_by_atime(dir) : exec_query(query, dir)
  end

  def self.list_notes_by_atime(dir, opts = {})
    cutoff = opts.fetch(:cutoff, nil)
    files = SortedSet.new()
    Find.find(dir) do |path|
      next if !File.file?(path) || File.basename(path)[0] == '.'
      atime = File.atime(path).to_i
      next if !cutoff.nil? && atime < cutoff
      files << [-atime, path]
    end
    files.map do |file|
      atime, path = file
      { 'title' => path_to_title(path), 'path'  => path }
    end
  end

  def self.list_tags(dir)
    path_items = mdfind_by_any('@', dir)
    path_items.flat_map {|pi| extract_tags(pi['path'])}.uniq.sort
  end

  def self.extract_tags(path)
    open(path) do |f|
      f.grep(/^tags.*@\S+/) do |line|
        line.scan(/(?<=^|\s)@\S+/)
      end
    end.flatten
  end

  def self.exec_query(query, dir)
    files = mdfind_by_name(query, dir)
    skip = Set.new(files.map {|f| f['path']})
    files += mdfind_by_any(query, dir).reject {|i| skip.include?(i['path'])}
    files
  end

  def self.mdfind_by_name(query, dir)
    exec_mdfind(['-name', query], dir)
  end

  def self.mdfind_by_any(query, dir)
    exec_mdfind([query], dir)
  end

  def self.exec_mdfind(args, dir)
    cmd = ['mdfind', '-onlyin', dir, '-interpret'] + args
    IO.popen(cmd) do |mdfind_io|
      mdfind_io.each_line.map do |line|
        path = line.strip
        { 'title' => path_to_title(path), 'path' => path }
      end
    end
  end

  def self.query_to_path(query)
    return [nil, nil] if query.empty?
    dirname, filename = File.split(query)
    ext = File.extname(filename).empty? ? config.ext : ''
    path = File.join(dirname, "#{filename}#{ext}").sub(%r{^[./]+}, '')
    [File.join(config.home, path), path]
  end

  def self.path_to_title(path)
    basedir = Pathname.new(config.home)
    Pathname.new(path).relative_path_from(basedir).sub_ext('')
  end
end
